# Geomancer (WIP)

My first Godot project. A bullet heaven twin-stick shooter.

![demo_10-23-25](https://github.com/user-attachments/assets/e7d283c6-c3a0-4561-9495-10b688a69f55)

## Local Development
- install Godot engine
- clone this repo and import to Godot
- ask me for assets, and put in `/assets`
- to change control setting, find `/utilities/settings.gd` and change defaults.controls.control_mode. gamepad and mouse+keyboard curently supported.

## Development Timeline and Features

**Week of 10/6 - Player Scene**
- ✅ Make Player spritesheet
- ✅ make weapon spritesheet
- ✅ Player movement mechanics
- ✅ Player weapon wheel
- ✅ Projectiles and weapon shooting

**Week of 10/13 - Enemy Scene**
- ✅ Make Enemy spritesheet
- ✅ Make enemy projectile spritesheet
- ✅ Enemy movement behavior as a state machine

**Week of 10/20 - Player vs. Enemy**
- ✅ Health bar/circle
- ✅ Make healthbar fade out after hit
- ✅ Add dying anim for enemy
- ✅ Enemy projectile hit detection
- ✅ Player projectile hit detection
- ✅ Player health bar/wheel
- ✅ Make world an infinite plane with grid background
- ✅ Scoring system (display time and number of enemies killed)
- ✅ Game Over on player death
- ✅ Restart button
- ✅ Title screen

**Week of 10/27 - Enemy Leveling**
- ✅ Enemy strength levels. Create different instances of the enemy scene with varying strengths (hp and projectile properties):
- ✅ Enemy colors to indicate strength level
- (med) Enemies prestige  as weapons do
- (high) Enemies grow stronger as a function of time and/or number of kills
- (low) varying enemy bullet patterns with aura to indicate

**Week of 11/3 - Weapon Leveling**
- (high) Enemies drop weapon XP
- (high) on XP gain weapon can do more damage, shoot faster, faster projectile speed, use less mana (opt.)
- (high) weapon strength indicated by smooth color gradient "aura" (particle effect maybe)
- (med) weapons can prestige, indicated by number next to it (after moving through full color gradient)
- (low) Mana wheel for player weapon(s)

**Week of 11/10 - Catch Up Buffer**
- Address existing bugs and other debt:
	- (critical) Fix enemy spawning
   	- (critical) fix issue with UI in fullscreen
- (med) add custom cursor sprite
- (med) Aim assist for gamepad (see existing branch)
- (critical) need a way to set or detect control mode setting

**Week of 11/17 - Polishing**
- (critical) Add sound effects and soundtrack
- (high) Design new player sprite sheet
- (low) implement player Adds if time permits

**Week of 11/24 - Release**
- Last minute tweaks
- Choos release platform(s)
- Release

## Target for release: 11/27/2025
