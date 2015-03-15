# Introduction #

Collision detection is crucial for 2D games and is a _very_ complex subject for 3D games.

Of course (for 2d) there are plenty solutions to detect collisions from bounded box to bounded circles... However what happen when you start to rotate or scale the 2D sprites? What happen when you have transparent pixels in your textures?

# Pixel Perfect Collision Detection #

This is the way collision detection is performed in TF4R. The existence of this wiki page dedicated to this subject comes from the lack of information available on the internet for a so important subject (IMHO).

Way to go...

## LWJGL setup ##

The base is to setup [PixelFormat](PixelFormat.md) used by LWJGL when creating the Display:

```
Display.create(new PixelFormat(8, // 8 bits for alpha buffer
                               8, 
                               8  // 8 bits for stencil buffer
                              ) 
              );
```

Both alpha buffer and stencil buffer sizing are important!

The default in LWJGL is:

```
Display.create();

// which means

Display.create(new PixelFormat(0, // 0 bit for alpha buffer => no alpha test possible
                               8, 
                               0  // 0 bit for stencil buffer => no stencil test possible
                              ) 
              );
```

As you can see, you may struggle a long time before seeing this problem (like me: 2 days).

## Collision detection ##

Now that the display is properly initialized (in ortho2d mode), you can start the main loop and before performing _real_ rendering:

```
Collision.begin();

    // INSIDE COLLISION LOOP 
    if( Collision.collide( entityA, entityB ) ) {
      // handle collision
    }

Collision.end();
```


### Theory ###

I've read a lot about the subject on different forums, in tutorials without having something working out of the box without even speaking of Java implementation!

The theory may seems complicated but in fact is simple:

By rendering a sprite A to a bitplan (with only 0 and 1), you can create a bitmask: 1 where any pixel will appear (i.e. full opacity regarding the alpha channel).

Then you can force _another_ sprite B to be displayed taking into account this bitmask:

If sprite B has a pixel that should be displayed then if the very same pixel (in terms of screen coordinates) has already been eligible to display some color (set to 1 by sprite A bitmask) then it means there is some collision.

There is the possibility to count the precise number of pixels already set to 1 by running an occlusion query (OpenGL **1.5** required).

Of course the sprites are not rendered to the screen by using the _glColorMask_ function; also this means a lot of sprites being rendered **several times**! However all the textures being loaded into video memory, the process should be fast especially regarding what is accomplished: perfect pixel collision detection.

Note that being in 2D, we don't perform depth testing (z testing). If we did, maybe some changes would be required (to check using the link on "The Framebuffer" for the possible values of zfail and zpass for function glStencilOp).

The following blog entry has a very good introduction with some pictures: [Collision Detection with Occlusion Queries Redux](http://kometbomb.net/2008/07/23/collision-detection-with-occlusion-queries-redux/)

### Code ###

Now the code (not optimized yet):

You can initialize the occlusion query and samples value that will holds the number of pixels that collided once and for all:

```
    private static int occquery;
    private static final IntBuffer samples = BufferUtils.createIntBuffer(1);

    public static void initialize() {
        // Query setup.
        IntBuffer queries = BufferUtils.createIntBuffer(1);
        GL15.glGenQueries(queries);
        occquery = queries.get(0);
    }
```

Then during the collision detection phase, we start the process, perform the process then end the process.

#### Begin ####

  1. Enable alpha channel testing for transparent sprites/textures area. Warning, this is different from blending used to display the textures!
  1. Sets the function (this could be done after creating the Display but placed here for understanding) to take into account during collision detection pixels that are "half-transparent"
  1. Enable scissor testing! (optimization to limit bitmask cleanup/creation/usage)
  1. Enable stencil testing! (the bitmask feature we'll use)
  1. Disable color components display to the screen during the collision detection tests.

```
GL11.glEnable(GL11.GL_ALPHA_TEST);
GL11.glAlphaFunc(GL11.GL_GEQUAL, 0.5f);
GL11.glEnable(GL11.GL_SCISSOR_TEST);
GL11.glEnable(GL11.GL_STENCIL_TEST);
GL11.glColorMask(false, false, false, false);
```

#### Collide test ####

  1. Perform a quick bounding box overlap test between our 2 sprites (the method must handle scaling operations on a and b if any)
  1. Limit work using scissors
  1. Clear the stencil buffer
  1. Prepare stencil bitmask initialization with first sprite glStencilFunc(GL\_ALWAYS with reference 1 and mask 1)
  1. We keep every pixels glStencilOp(GL\_REPLACE, GL\_REPLACE, GL\_REPLACE)
  1. We can now draw our sprite to the stencil buffer only (after scissor and alpha channel testing) taking into account the fact that we are inside the collision detection phase thus don't perform animation!
  1. Next we setup the stencil bitmask operation to write only where there are 1 (set when drawing sprite a): glStencilFunc(GL\_EQUAL with reference 1 and mask 1)
  1. We keep only pixels that pass the test glStencilOp(GL\_KEEP, GL\_KEEP, GL\_KEEP) (depth test disabled since we are in 2D!)
  1. We also start our occlusion query to start counting for **common pixels**
  1. Now draw sprite b
  1. Stop occlusion query
  1. Loop until occlusion query finish!
  1. Retrieve occlusion query result
  1. Return collision detected if the result > 0

```
if( boundingBoxOverlap( a, b ) ) {
    // compute scissor parameters
    ...
    GL11.glScissor(minLeft + Game.SCREEN_WIDTH_DIV_2, minBottom + Game.SCREEN_HEIGHT_DIV_2, Math.abs(maxRight - minLeft), Math.abs(maxTop - minBottom));

    GL11.glClear(GL11.GL_STENCIL_BUFFER_BIT);

    GL11.glStencilFunc(GL11.GL_ALWAYS, 1, 1);
    GL11.glStencilOp(GL11.GL_REPLACE, GL11.GL_REPLACE, GL11.GL_REPLACE);

    a.draw( true );


    GL11.glStencilFunc(GL11.GL_EQUAL, 1, 1);
    GL11.glStencilOp(GL11.GL_KEEP, GL11.GL_KEEP, GL11.GL_KEEP);

    GL15.glBeginQuery(GL15.GL_SAMPLES_PASSED, occquery);

    b.draw( true );

    GL15.glEndQuery(GL15.GL_SAMPLES_PASSED);

    do {
        GL15.glGetQueryObject(occquery, GL15.GL_QUERY_RESULT_AVAILABLE, samples);
    } while (samples.get(0) == 0);

    GL15.glGetQueryObject(occquery, GL15.GL_QUERY_RESULT, samples);

    return samples.get(0) > 0;
}
else {
    return false;
}
```

#### End ####

  1. Reactivate coloring to screen
  1. Disable stencil testing
  1. Disable scissor testing
  1. Disable alpha channel testing

```
GL11.glColorMask(true, true, true, true);
GL11.glDisable(GL11.GL_STENCIL_TEST);
GL11.glDisable(GL11.GL_SCISSOR_TEST);
GL11.glDisable(GL11.GL_ALPHA_TEST);
```

### Optimizations ###

Some optimizations are possible:
  * group collision detection per type: player vs anything lethal (enemies, land, bullets...)
  * use all possible stencil bit plans before clearing it
  * return collision detected if more than 10 pixels collided to avoid too perfect collision detection (to be tested)

# References #

  * [Pixel perfect collision detection using GPU occlusion queries](http://blogs.msdn.com/shawnhar/archive/2008/12/31/pixel-perfect-collision-detection-using-gpu-occlusion-queries.aspx)
  * [Collision Detection with Occlusion Queries Redux](http://kometbomb.net/2008/07/23/collision-detection-with-occlusion-queries-redux/)
  * [The (OpenGL) Framebuffer](http://glprogramming.com/red/chapter10.html)