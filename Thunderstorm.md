
```
package tf4r;

import org.lwjgl.input.Keyboard;
import org.lwjgl.openal.AL;
import org.lwjgl.opengl.*;
import org.lwjgl.util.glu.GLU;
import org.lwjgl.util.vector.Vector3f;
import org.lwjgl.util.vector.Vector4f;
import tf4r.loader.ContentLoader;
import tf4r.loader.sound.SoundManager;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.awt.image.DataBufferByte;
import java.io.File;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.IntBuffer;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import static org.lwjgl.opengl.GL11.*;

/**
 */
public class TestLightning {
    private static final boolean ORTHO = true;
    private static final int WIDTH = 640;
    private static final int HEIGHT = 480;

    final static Random rand = new Random(System.currentTimeMillis());

    static class Rain {
        private final Vector4f[] rain = new Vector4f[400];
        private final float x = 30f;
        private final float xStep = x * 0.0005f;
        private final float y = -50f;
        private final float yStep = y * 0.0005f;

        public Rain(int screenWidth, int screenHeight) {
            for (int i = 0; i < rain.length; i++) {
                rain[i] = new Vector4f();
                rain[i].x = (rand.nextInt(screenWidth) - screenWidth / 2) / (float) screenWidth;
                rain[i].y = (rand.nextInt(screenHeight) - screenHeight / 2) / (float) screenHeight;
                rain[i].z = rain[i].x + x / (float) screenWidth;
                rain[i].w = rain[i].y + y / (float) screenHeight;
            }
        }

        public void draw() {
            GL11.glEnable(GL11.GL_BLEND);
            GL11.glBlendFunc(GL11.GL_SRC_ALPHA, GL11.GL_ONE_MINUS_SRC_ALPHA);

            glDisable(GL_TEXTURE_2D);
            GL11.glLineWidth(2f);

            glLoadIdentity();
            MyLWJGLUtil.glBegin(GL11.GL_LINES);
            {
                MyLWJGLUtil.glColor4f(0.313f, 0.313f, 0.313f, 0.1f + rand.nextFloat() * 0.2f);
                glNormal3f(0, 0, 1);
                for (Vector4f r : rain) {
                    MyLWJGLUtil.glVertex3f(r.x, r.y, -1);
                    MyLWJGLUtil.glVertex3f(r.z, r.w, -1);
                    r.x += xStep;
                    r.y += yStep;
                    r.z += xStep;
                    r.w += yStep;

                    if (r.y < -0.5f/*-HEIGHT / 2*/) {
                        //r.x = rand.nextInt(WIDTH * 2) - WIDTH - x;
                        r.x = rand.nextFloat() * 1.33333f - .5f * 1.33333f;
                        //r.y = HEIGHT / 2 - y;
                        r.y = rand.nextFloat() * 0.5f - .25f;
                        r.z = r.x + x / 640f;
                        r.w = r.y + y / 480f;
                    }
                }
            }
            MyLWJGLUtil.glEnd();
        }
    }

    static class Lightning {
        final List<Vector3f[]> lightning = new ArrayList<Vector3f[]>();
        private final int screenHeight;
        private final int screenWidth;
        private boolean finishedDisplayLightning;
        private int displayFlash;
        private int flashSphereTextureID;
        private float initX;
        private float initY;
        private float finishAlive;
        private boolean hasToPlaySound;
        private int playSound;

        public Lightning(int screenWidth, int screenHeight, int flashSphereTextureID) {
            this.screenWidth = screenWidth;
            this.screenHeight = screenHeight;
            this.flashSphereTextureID = flashSphereTextureID;

            reset();

            // for bloom
            createOffScreenBuffer();
        }

        public void reset() {
            lightning.clear();
            alive = finishAlive = 0f;
            displayFlash = 0;
            finishedDisplayLightning = false;
            hasToPlaySound = true;
            playSound = 5 + rand.nextInt(30);

            Vector3f[] lightning0 = new Vector3f[43];
            lightning.add(lightning0);
            // starting point
            initX = rand.nextFloat() * .5f - .25f;
            initY = .5f - rand.nextFloat() * .25f;
            lightning0[0] = new Vector3f(initX, initY, 0);

            // build main arcs
            final float STEP = .05f;
            for (int i = 1; i < lightning0.length; i++) {
                float x = Math.abs(rand.nextFloat() * STEP * .8f - STEP * (Math.abs(initX)) / 2f);
                if (initX > 0) {
                    x *= -1f;
                }
                final float y = rand.nextFloat() * STEP;
                lightning0[i] = new Vector3f(lightning0[i - 1].x + x, lightning0[i - 1].y - y, (float) i);

                // build other arcs
                if (rand.nextFloat() > .85f && i < 25) {
                    addArc(lightning0[i], i, 1);
                }
            }
        }

        private int BLOOM_TEXTURE_ID;

        private void createOffScreenBuffer() {
            IntBuffer buf = ByteBuffer.allocateDirect(4).order(ByteOrder.nativeOrder()).asIntBuffer();
            GL11.glGenTextures(buf); // Create Texture In OpenGL
            BLOOM_TEXTURE_ID = buf.get(0);
            GL11.glBindTexture(GL11.GL_TEXTURE_2D, BLOOM_TEXTURE_ID);
            GL11.glTexParameteri(GL11.GL_TEXTURE_2D, GL11.GL_TEXTURE_MAG_FILTER, GL11.GL_LINEAR);
            GL11.glTexParameteri(GL11.GL_TEXTURE_2D, GL11.GL_TEXTURE_MIN_FILTER, GL11.GL_LINEAR);
            final int bytesPerPixel = 4;
            ByteBuffer scratch = ByteBuffer.allocateDirect(WIDTH * HEIGHT * bytesPerPixel);
            GL11.glTexParameteri(GL11.GL_TEXTURE_2D, GL11.GL_TEXTURE_WRAP_S, GL11.GL_REPEAT);
            GL11.glTexParameteri(GL11.GL_TEXTURE_2D, GL11.GL_TEXTURE_WRAP_T, GL11.GL_REPEAT);
            GL11.glTexImage2D(GL11.GL_TEXTURE_2D, 0, GL11.GL_RGBA, WIDTH, HEIGHT, 0, GL11.GL_RGBA, GL11.GL_UNSIGNED_BYTE, scratch);
        }

        private void addArc(Vector3f origin, int iter, int generation) {
            Vector3f[] arc = new Vector3f[5 + rand.nextInt(10)];
            lightning.add(arc);
            arc[0] = origin;
            final float STEP = .05f;
            boolean xDir = rand.nextBoolean();
            for (int i = 1; i < arc.length; i++) {
                float x = Math.abs(rand.nextFloat() * 3f * STEP - STEP * 1.5f) * 1f / (float) generation;
                if (xDir) {
                    if (rand.nextFloat() < .95f) {
                        x *= -1;
                    } else {
                        xDir = !xDir;
                    }
                } else {
                    if (rand.nextFloat() > .95f) {
                        x *= -1;
                        xDir = !xDir;
                    }
                }
                final float y = rand.nextFloat() * STEP / 1.5f * 1f / (float) generation;
                arc[i] = new Vector3f(arc[i - 1].x + x, arc[i - 1].y - y, i + iter);

                if (rand.nextFloat() > .92f && lightning.size() < 60) {
                    addArc(arc[i], i + iter, generation + 1);
                }
            }
        }

        private float alive;

        private void draw() {
            if (playSound > 0 || displayFlash > 0 || isFinished()) {
                return;
            }

            alive += 3f;

            GL11.glMatrixMode(GL11.GL_PROJECTION);
            MyLWJGLUtil.glLoadIdentity();
            GL11.glViewport(0, 0, screenWidth, screenHeight);
            GLU.gluPerspective(45.0f, (float) screenWidth / (float) screenHeight, 1f, 1000.0f);

            GL11.glMatrixMode(GL11.GL_MODELVIEW);
            MyLWJGLUtil.glLoadIdentity();

            GL11.glDisable(GL11.GL_DEPTH_TEST);
            GL11.glDepthMask(false);

            glEnable(GL_LINE_SMOOTH);
            glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);

            GL11.glLineWidth(3f);
            MyLWJGLUtil.glColor4f(1, 1, 1, finishAlive > 0 ? finishAlive * .01f : 1);

            glDisable(GL_TEXTURE_2D);

            finishedDisplayLightning = true;

            for (Vector3f[] arc : lightning) {
                MyLWJGLUtil.glBegin(GL11.GL_LINE_STRIP);
                glNormal3f(0, 0, 1);
                for (Vector3f r : arc) {
                    if (r.z > alive) {
                        finishedDisplayLightning = false;
                        break;
                    }
                    MyLWJGLUtil.glVertex3f(r.x, r.y, -1);
                }
                MyLWJGLUtil.glEnd();

                MyLWJGLUtil.glColor4f(.5f, .5f, .5f, finishAlive > 0 ? finishAlive * .01f : .8f);
                GL11.glLineWidth(2f);
            }

            glEnable(GL_TEXTURE_2D);

            if (finishedDisplayLightning && finishAlive == 0) {
                displayFlash = 10;
            }
        }

        public boolean isFinished() {
            return finishedDisplayLightning && displayFlash == 0 && finishAlive == 0f;
        }

        public void captureScreenForBloom() {
            if (displayFlash > 0 || isFinished()) {
                return;
            }

            glEnable(GL_TEXTURE_2D);

            GL11.glBindTexture(GL11.GL_TEXTURE_2D, BLOOM_TEXTURE_ID);
            GL11.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            GL11.glCopyTexSubImage2D(GL11.GL_TEXTURE_2D, 0, 0, 0, 0, 0, screenWidth, screenHeight);
        }

        public void bloom() {
            if (isFinished()) {
                return;
            }

            glMatrixMode(GL_PROJECTION);
            glLoadIdentity();
            glOrtho(0, WIDTH, HEIGHT, 0, 0.1f, 2048);
            glMatrixMode(GL_MODELVIEW);
            glLoadIdentity();
            glTranslatef(0, 0, -1.0f);
            glDisable(GL_CULL_FACE);
            glDisable(GL_FOG);
            glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
            //Render full-screen effects
            glBlendFunc(GL_ONE, GL_ONE);
            glDisable(GL_DEPTH_TEST);
            glDepthMask(false);

            if (finishedDisplayLightning && displayFlash > 0) {
                displayFlash--;

                glDisable(GL_TEXTURE_2D);

                glBegin(GL_QUADS);
                {
                    GL11.glColor4f(1, 1, 1, 1);
                    glVertex2i(0, HEIGHT);
                    glVertex2i(0, 0);
                    glVertex2i(WIDTH, 0);
                    glVertex2i(WIDTH, HEIGHT);
                }
                glEnd();

                glEnable(GL_TEXTURE_2D);

                if (displayFlash <= 0) {
                    displayFlash = 0;
                    finishAlive = alive;
                }
            } else {

                if( alive > 3 ) {
                    glEnable(GL_TEXTURE_2D);

                    float a = .3f;

                    //Simple bloom effect
                    glBegin(GL_QUADS);
                    //color = WorldBloomColor () * BLOOM_SCALING;
                    final int bloom_radius = 3;
                    final int bloom_step = 1;
                    for (int x = -bloom_radius; x <= bloom_radius; x += bloom_step) {
                        GL11.glColor4f(.07f, .051f, .09f, a);
                        //GL11.glColor4f(.02f, .028f, .03f, a);
                        for (int y = -bloom_radius; y <= bloom_radius; y += bloom_step) {
                            if (Math.abs(x) == Math.abs(y) && x != 0)
                                continue;

                            glTexCoord2f(0, 0);
                            glVertex2i(x, y + HEIGHT);
                            glTexCoord2f(0, 1);
                            glVertex2i(x, y);
                            glTexCoord2f(1, 1);
                            glVertex2i(x + WIDTH, y);
                            glTexCoord2f(1, 0);
                            glVertex2i(x + WIDTH, y + HEIGHT);
                        }

                        if (x < 0) {
                            a += .1f;
                        } else if (x > 0) {
                            a -= .1f;
                        }
                    }
                    glEnd();

                    GL11.glMatrixMode(GL11.GL_PROJECTION);
                    MyLWJGLUtil.glLoadIdentity();
                    GL11.glViewport(0, 0, screenWidth, screenHeight);
                    GLU.gluPerspective(45.0f, (float) screenWidth / (float) screenHeight, 1f, 1000.0f);

                    GL11.glMatrixMode(GL11.GL_MODELVIEW);
                    MyLWJGLUtil.glLoadIdentity();

                    glBlendFunc(GL_SRC_ALPHA, GL_ONE);

                    GL11.glBindTexture(GL11.GL_TEXTURE_2D, flashSphereTextureID);

                    final float scale = 15f;

                    final float temp = finishAlive == 0f ? alive : finishAlive;

                    if (finishAlive > 0f) {
                        finishAlive -= 1.5f;
                    } else {
                        finishAlive = 0;
                    }

                    // draw flash sphere
                    glBegin(GL_QUADS);
                    {
                        //color = WorldBloomColor () * BLOOM_SCALING;
                        GL11.glColor4f(1, 1, 1, .005f * temp);
                        //GL11.glColor4f(1, 1, 1, 1);
                        //GL11.glColor4f(.02f, .028f, .03f, a);
                        glTexCoord2f(0, 0);
                        glVertex3f(initX - temp / screenWidth * scale, initY + temp / screenHeight * scale, -1);
                        glTexCoord2f(0, 1);
                        glVertex3f(initX - temp / screenWidth * scale, initY - temp / screenHeight * scale, -1);
                        glTexCoord2f(1, 1);
                        glVertex3f(initX + temp / screenWidth * scale, initY - temp / screenHeight * scale, -1);
                        glTexCoord2f(1, 0);
                        glVertex3f(initX + temp / screenWidth * scale, initY + temp / screenHeight * scale, -1);
                    }
                    glEnd();

                }

            }
        }

        public void sound() {
            playSound--;
            if (hasToPlaySound) {
                switch (rand.nextInt(6)) {
                    case 0:
                        SoundManager.playMusic("file:///" + new File("..", "modules/levelchaos/src/data/levelchaos/music/thunder strike 1.mp3").getAbsolutePath());
                        break;
                    case 1:
                        SoundManager.playMusic("file:///" + new File("..", "modules/levelchaos/src/data/levelchaos/music/thunder strike 2.mp3").getAbsolutePath());
                        break;
                    case 2:
                        SoundManager.playMusic("file:///" + new File("..", "modules/levelchaos/src/data/levelchaos/music/thunder strike 3.mp3").getAbsolutePath());
                        break;
                    case 3:
                        SoundManager.playMusic("file:///" + new File("..", "modules/levelchaos/src/data/levelchaos/music/thunder strike 4.mp3").getAbsolutePath());
                        break;
                    case 4:
                        SoundManager.playMusic("file:///" + new File("..", "modules/levelchaos/src/data/levelchaos/music/thunder strike 5.mp3").getAbsolutePath());
                        break;
                    case 5:
                        SoundManager.playMusic("file:///" + new File("..", "modules/levelchaos/src/data/levelchaos/music/thunder strike 6.mp3").getAbsolutePath());
                        break;
                }

                hasToPlaySound = false;
            }
        }
    }


    public static void main(String[] args) {
        try {
            Display.setFullscreen(true);
            try {
                final DisplayMode[] availableDisplayModes = org.lwjgl.util.Display.getAvailableDisplayModes(
                        WIDTH, HEIGHT, WIDTH, HEIGHT, 32, 32, 60, 60);
                org.lwjgl.util.Display.setDisplayMode(availableDisplayModes, new String[]{
                        "width=" + WIDTH,
                        "height=" + HEIGHT,
                        "freq=" + 60,
                        "bpp=" + 32
                });
            } catch (Exception e) {
                System.err.println("ERROR: could not start full screen mode, switching to windowed mode!");
                try {
                    // wait 3s so that the player sees the message!
                    Thread.sleep(3000L);
                } catch (InterruptedException ignored) {
                }
            Display.setDisplayMode(new DisplayMode(WIDTH, HEIGHT));
            }


            Display.create(new PixelFormat(32, 8, 24, 8, 0));


            MyLWJGLUtil.init();

            SoundManager.resetGlobalMusicVolume();
            SoundManager.setGlobalMusicVolume(.5f);
            //SoundManager.loadMusic("file:///" + new File("..", "modules/levelchaos/src/data/levelchaos/music/wind.mp3").getAbsolutePath(), "Wind");
            SoundManager.loadMusic("file:///" + new File("..", "modules/levelchaos/src/data/levelchaos/music/rain.mp3").getAbsolutePath(), "Rain");
            SoundManager.loadMusic("file:///" + new File("..", "modules/levelchaos/src/data/levelchaos/music/thunder strike 1.mp3").getAbsolutePath(), "TS1");
            SoundManager.loadMusic("file:///" + new File("..", "modules/levelchaos/src/data/levelchaos/music/thunder strike 2.mp3").getAbsolutePath(), "TS2");
            SoundManager.loadMusic("file:///" + new File("..", "modules/levelchaos/src/data/levelchaos/music/thunder strike 3.mp3").getAbsolutePath(), "TS3");
            SoundManager.loadMusic("file:///" + new File("..", "modules/levelchaos/src/data/levelchaos/music/thunder strike 4.mp3").getAbsolutePath(), "TS4");
            SoundManager.loadMusic("file:///" + new File("..", "modules/levelchaos/src/data/levelchaos/music/thunder strike 5.mp3").getAbsolutePath(), "TS5");
            SoundManager.loadMusic("file:///" + new File("..", "modules/levelchaos/src/data/levelchaos/music/thunder strike 6.mp3").getAbsolutePath(), "TS6");
            SoundManager.initializeSoundSystem(new ContentLoader("file://../"));

            //SoundManager.playMusic("file:///" + new File("..", "modules/levelchaos/src/data/levelchaos/music/wind.mp3").getAbsolutePath());

            glClearColor(0, 0, 0, 1f); // blue

            float ratio = WIDTH / HEIGHT;

            int flashSphere = loadTexture("./flash sphere.png", 256, 256);
            final Lightning l = new Lightning(WIDTH, HEIGHT, flashSphere);

            final Rain r = new Rain(WIDTH, HEIGHT);

            glDisable(GL_FOG);
            GL11.glHint(GL11.GL_PERSPECTIVE_CORRECTION_HINT, GL11.GL_NICEST);
            GL11.glShadeModel(GL11.GL_SMOOTH);

            GL11.glMatrixMode(GL11.GL_PROJECTION);
            MyLWJGLUtil.glLoadIdentity();
            GL11.glViewport(0, 0, WIDTH, HEIGHT);
            GLU.gluPerspective(45.0f, (float) WIDTH / (float) HEIGHT, 1f, 1000.0f);

            GL11.glMatrixMode(GL11.GL_MODELVIEW);
            MyLWJGLUtil.glLoadIdentity();

            GL11.glDisable(GL11.GL_ALPHA_TEST);
            GL11.glDisable(GL11.GL_FOG);
            GL11.glDisable(GL11.GL_LIGHTING);
            GL11.glEnable(GL11.GL_BLEND);
            GL11.glBlendFunc(GL11.GL_SRC_ALPHA, GL11.GL_ONE);

            int i = 0;
            final float step = 0.001f;
            int framesWithoutStorm = 0;

            SoundManager.playMusic("file:///" + new File("..", "modules/levelchaos/src/data/levelchaos/music/rain.mp3").getAbsolutePath());

            while (i < 5000 && !Keyboard.isKeyDown(Keyboard.KEY_ESCAPE) && !Display.isCloseRequested()) {
                Thread.yield();

                final long s = System.currentTimeMillis();
                i++;

                glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

                l.sound();

                l.draw();

                r.draw();
                
                l.captureScreenForBloom();

                l.bloom();


                // flip buffers
                Display.update();
                Display.sync(60);

                if (l.isFinished()) {
                    framesWithoutStorm--;
                    if (framesWithoutStorm <= 0) {
                        l.reset();
                    }
                } else {
                    framesWithoutStorm = rand.nextInt(150) + 150;
                }

                final long e = System.currentTimeMillis();
                //System.out.println((float) 1/*i*/ / (float) (e - s) * 1000 + " FPS");
            }

            Display.destroy();

            AL.destroy();
        } catch (Throwable t) {
            t.printStackTrace();
        }
    }

    private static int loadTexture(String path, int width, int height) throws IOException {
        BufferedImage a = ImageIO.read(new File(path));
        byte[] data = ((DataBufferByte) a.getRaster().getDataBuffer()).getData();

        switch (a.getType()) {
            case BufferedImage.TYPE_4BYTE_ABGR:
                convertFromARGBToBGRA(data);
                break;
            case BufferedImage.TYPE_3BYTE_BGR:
                convertFromBGRToRGB(data);
                break;
        }

        final int bytesPerPixel = a.getColorModel().getPixelSize() / 8;

        final ByteBuffer scratch = ByteBuffer.allocateDirect(width * height * bytesPerPixel).order(ByteOrder.nativeOrder());
        data = ((DataBufferByte) a.getRaster().getDataBuffer()).getData();

        for (int i = 0; i < height; i++) {
            scratch.put(data, ((0 + i) * a.getWidth()) * bytesPerPixel, width * bytesPerPixel);
        }

        scratch.rewind();

        final IntBuffer buf = ByteBuffer.allocateDirect(4).order(ByteOrder.nativeOrder()).asIntBuffer();
        // Create Texture In OpenGL
        glGenTextures(buf);

        // System.out.println("Created texture: " + buf.get(0) + " (alpha: " + buffImage.getColorModel().hasAlpha() + ")");

        // Create Nearest Filtered Texture
        glBindTexture(GL_TEXTURE_2D, buf.get(0));
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL12.GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL12.GL_CLAMP_TO_EDGE);

        GL11.glTexEnvf(GL11.GL_TEXTURE_ENV, GL11.GL_TEXTURE_ENV_MODE, EXTTextureEnvCombine.GL_COMBINE_EXT);
        GL11.glTexEnvi(GL11.GL_TEXTURE_ENV, EXTTextureEnvCombine.GL_COMBINE_RGB_EXT, GL11.GL_MODULATE);

        // manage openGL pixel types
        if (!a.getColorModel().hasAlpha()) {
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, scratch);
        } else {
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, scratch);
        }

        return buf.get(0);
    }

    private static void convertFromARGBToBGRA(final byte[] data) {
        final int size = data.length;
        for (int i = 0; i < size; i += 4) {
            final int a = data[i] & 0x000000FF;
            final int r = data[i + 1] & 0x000000FF;
            final int g = data[i + 2] & 0x000000FF;
            final int b = data[i + 3] & 0x000000FF;

            data[i] = (byte) b;
            data[i + 1] = (byte) g;
            data[i + 2] = (byte) r;
            data[i + 3] = (byte) a;
        }
    }

    private static void convertFromBGRToRGB(final byte[] data) {
        final int size = data.length;
        for (int i = 0; i < size; i += 3) {
            final int b = data[i] & 0xFF;
            final int g = data[i + 1] & 0xFF;
            final int r = data[i + 2] & 0xFF;

            data[i] = (byte) r;
            data[i + 1] = (byte) g;
            data[i + 2] = (byte) b;
        }
    }

}

```