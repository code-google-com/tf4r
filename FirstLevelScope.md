TODO:
  * implement information panel
  * adapt diffculty according to the mission level

IDEAS:
  * Asteroids collisions side-effect: http://www.euclideanspace.com/physics/dynamics/collision/twod/index.htm

  * For asteroid field:<br>
<img src='http://www.satelliteinternet.com/news/wp-content/uploads/2009/12/05-Asteroids.jpg'></li></ul>

WORK IN PROGRESS:

<a href='http://www.youtube.com/watch?feature=player_embedded&v=1KBs0ba_iZE' target='_blank'><img src='http://img.youtube.com/vi/1KBs0ba_iZE/0.jpg' width='425' height=344 /></a>

<a href='http://www.youtube.com/watch?feature=player_embedded&v=7rUUIMwOK4A' target='_blank'><img src='http://img.youtube.com/vi/7rUUIMwOK4A/0.jpg' width='425' height=344 /></a>

<img src='http://tf4r.googlecode.com/svn/wiki/img/screenshot%20level%201%20-%20asteroid%20field%205.jpg' width='640' height='480'>

<img src='http://tf4r.googlecode.com/svn/wiki/img/screenshot%20level%201%20-%20asteroid%20field%204.jpg' width='640' height='480'>

<img src='http://tf4r.googlecode.com/svn/wiki/img/screenshot%20level%201%20-%20asteroid%20field%203.jpg' width='640' height='480'>

<img src='http://tf4r.googlecode.com/svn/wiki/img/screenshot%20level%201%20-%20asteroid%20field%202.jpg' width='640' height='480'>

<img src='http://tf4r.googlecode.com/svn/wiki/img/screenshot%20level%201%20-%20asteroid%20field.jpg' width='640' height='480'>

DONE 2010/08/03:<br>
<ul><li>adapted difficulty to mission level</li></ul>

DONE 2010/06/24:<br>
<ul><li>corrected <a href='http://code.google.com/p/tf4r/issues/detail?id=1'>issue #1</a></li></ul>

DONE 2010/06/08:<br>
<ul><li>corrected <a href='http://code.google.com/p/tf4r/issues/detail?id=2'>issue #2</a></li></ul>

DONE 2010/06/05:<br>
<ul><li>corrected minor bugs for game over sequence<br>
</li><li>optimized mp3 music loading through local disk cache<br>
</li><li>allow to skip the intro of this level<br>
</li><li>corrected ENTER key listener on game start screen<br>
</li><li>made big asteroids in front transparent</li></ul>

DONE 2010/05/31:<br>
<ul><li>changed blinking effect when ship revives (transparency)<br>
</li><li>better explosion pattern when ship destroyed<br>
</li><li>refilled escape capsule shield when ship revives</li></ul>

DONE 2010/05/29:<br>
<ul><li>allowed to restart game</li></ul>

DONE 2010/05/28:<br>
<ul><li>changed fire key: RIGHT SHIFT => C<br>
</li><li>implemented asteroids explosions (smoke)<br>
</li><li>reduced volume for some sound effects<br>
</li><li>accelerated some intro parts</li></ul>

DONE 2010/05/27:<br>
<ul><li>generated the first video on youtube<br>
</li><li>added game.properties support for HTTP proxy setup<br>
</li><li>implemented scrollable viewport feature ala TF4<br>
</li><li>reduced screen to 640x480<br>
</li><li>implemented black fade out effect for the end of the level</li></ul>

DONE 2010/05/26:<br>
<ul><li>finished pirats headquarter design<br>
</li><li>optimized star field to prevent garbage collection</li></ul>

DONE 2010/05/23:<br>
<ul><li>designed pirats headquarter</li></ul>

DONE 2010/05/21:<br>
<ul><li>improved asteroids generator using a pool of asteroids to avoid garbage collection</li></ul>

DONE 2010/05/20:<br>
<ul><li>made spiders fire laser beams</li></ul>

DONE 2010/05/19:<br>
<ul><li>resized screen to 800x600</li></ul>

DONE 2010/05/17-18:<br>
<ul><li>studied ARB point sprites (benchmark developped to test on different configurations)</li></ul>

DONE 2010/05/13:<br>
<ul><li>added escape capsule mini reactor<br>
</li><li>added spiders walking on asteroids</li></ul>

DONE 2010/05/12:<br>
<ul><li>corrected minor bugs (entities ratio related)</li></ul>

DONE 2010/05/11:<br>
<ul><li>added window with text displaying while the navy voice is reading it</li></ul>

DONE 2010/05/10:<br>
<ul><li>added asteroids belt<br>
</li><li>added big asteroids in frontground</li></ul>

DONE 2010/05/09:<br>
<ul><li>prepare level intro directly from TF4 ending<br>
</li><li>packaged TF4R for windows<br>
</li><li>corrected bugs related to deployment/game part downloading<br>
</li><li>added level scenes concept<br>
</li><li>optimized asteroid textures loading</li></ul>

DONE 2010/05/07:<br>
<ul><li>prepared level intro pictures<br>
</li><li>added asteroid field rock (stressing) music<br>
</li><li>added planet<br>
</li><li>optimized star field parallax scrolling<br>
</li><li>enhanced asteroid field generator (more realistic and more kamikaze!)</li></ul>

DONE 2010/05/06:<br>
<ul><li>reduced scissor area for collision detection<br>
</li><li>moved from direct mode to VBOs<br>
</li><li>changed push/load identity/pop to load identity</li></ul>

DONE 2010/05/05:<br>
<ul><li>implement star field background parallax scrolling</li></ul>

DONE 2010/05/03:<br>
<ul><li>implemented scissors+stencil+occlusion query for pixel perfect collision detection</li></ul>

DONE 2010/04/30:<br>
<ul><li>started scissors+stencil+occlusion query for accurate collision detection<br>
</li><li>implemented asteroid generator</li></ul>

DONE 2010/04/29:<br>
<ul><li>created 4 animated asteroids<br>
</li><li>added support for non power of 2 textures (scaling with JAI or repeating texture parts)<br>
</li><li>added support for animated entities with less than cols x rows animation frames<br>
</li><li>implemented partial music looping for .mp3 files</li></ul>

DONE 2010/04/28:<br>
<ul><li>corrected ship animations<br>
</li><li>implemented partial music looping for .wav files<br>
</li><li>integrated freetts</li></ul>

DONE 2010/04/27:<br>
<ul><li>implemented "ridiculous" escape capsule ship<br>
</li><li>implemented temporarily activable shield (including sounds)<br>
</li><li>found asteroids textures