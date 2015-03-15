# High concept #

This shmup intends to continue the story of the tf4 pilot just after the escape performed at the end of the game. A concept of RPG _may_ also be added to the game: story, XP and levels up ...

# Game description #

The story starts just after the destruction of the Vios Fortress when the pilot has to eject from the damaged Rynex ship (it is a parallel story to the Thunder Force V game).

## First level: Escape ##

The very first level will then consist of the escape from an asteroid field with a ridiculous escape capsule (which has a _temporarily_ activable shield).

The escape capsule will crash on a big meteor owned by space pirats. The pilot will then _maybe_ loose memory (which could give good story opportunities in future).

The pilot will be made prisonner for some time but will sucessfully escape (helped by someone?) from the pirat headquarter by stealing a ship (now commonly used by people): the FIRE LEO-03 Styx (from <a href='http://en.wikipedia.org/wiki/Thunder_Force_III#Story'>Thunder Force III</a>).

This first level is very peculiar: the horizontal scrolling will take place **as the end of TF4** with enemies coming from the left! However here enemies will consist of an asteroid field which really wants to play kamikaze :)

The end of this level - the pirats' asteroid landing - will be very cool!

## Second level: New start ##

Some weeks will pass while the pilot is still prisonner. After some weeks, the prison door will suddently be unlocked by some unknown reasons...

The pilot will find his way to the docks where he'll steal a FIRE LEO-03 Styx. Just when he takes off, the alarm will start and now the pilot must again escape the pirat HQ.

Flying quickly through thin corridors, you the pilot will have to:
  * choose between some paths
  * catch the weapon bonus **at all prices**
  * destroy the dock door; only an enhanced weapon has the power to destroy it in the small amount of time the pilot has (because the ship is flying really fast)

After this successful (second) escape, the ship will reach the Galaxy Federation Space Portal but it is guarded by some GF entity. Only the destruction of this guardian will allow the pilot to finally reach back the GF HQ!

## Inter level scene ##

Once the pilot came back to the Galaxy Federation HQ he will have access to a larger area where he can decide for the next level to go (also according to mission given by the GF).

Optionally (has to be decided), he can replay a previous level in order to win some XP for example.

**Warning** the lines below are here only for records since the concept of shop will _certainly_ disappear.

This inter level scene will show a large space map, with hidden parts of course. During this, the player can also go shopping for new weapons, shields, claws and also exchange...

# Technical level design #

Each level will be a standalone Java ARchive downloaded just in time (from google code).

A _core_ JAR and an other _shared_ JAR will be responsible to manage common game tasks (load textures, sounds or musics, make collision detection, draw everything and treat player inputs).

Each level will be run inside its own class loader.

The minimum system supported will require OpenGL 1.5!

# RPG concepts #

## Saving points ##

Having some properties of RPG games means the player will progress with XP/money - craft responsiveness and capacities like number of weapon usable during a level, several weapon levels, new weapon to buy between levels... - and thus a _saving model_ must be implemented.

While it would be a standard model to save the player progression once a level is finished I prefer other possibilities (open to discussion) as:
  * get a bonus that allows saving progression when the level is finished
  * possibility to save each n (5?) finished levels
  * maybe a _maniac_ difficulty that prevent any saving point, only the usual 6 "continue"
  * other?

## XP points ##

XP points will continuously increase as the player progress in the game. By "continuously" I really mean every frame, some XP are obtained.

If for some reasons the player loose ship power, then some XP will also be removed; these XP points will really mean something.

At the end of a level it will be possible to convert XP into money in order to:
  * buy new weapons (each weapon will have say 8 levels of power, being hit severly will mean loosing one level of the equipped weapon)
  * buy weapon slots (the usual 5 slots are not available at the beginning, the number will increase with XP points)
  * repair the ship and the weapons
  * increase ship capacities (with a point system ala diablo)
  * buy shields or mega-bombs
  * ...

## Difficulty aware areas ##

While some areas will be categorized as easy, average or difficult (if not _maniac_ ;)), the XP counting system will adapt itself:
  * much more XP points are removed if hit by enemies in easy areas
  * more XP points are continuously gained in case of difficult areas

## Pilot's memory ##

When the pilot lands on the pirat asteroid at the very beginning of the game he will loose memory. This will have consequences on pilot capacities (ship less controlable, some weapons not available yet).

While progressing into the game, the pilot will then get back some memories and thus will be able to use forgotten abilities:
  * hyper-space,
  * ship much more controlable,
  * weapon shoot frequency increased,
  * more speed levels available,
  * ...

## Future levels ##

Possibility to meet new people:
  * pilots (and then new ships like one that can steal enemies weapons ala megaman)
  * friends for game hints
  * ...