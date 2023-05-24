/// @description Insert description here
// You can write your code in this editor

animation_timer += animation_speed

if (animation_timer >= 1)
{
	frame++;
	animation_timer = 0
	show_debug_message("works?")
	event_user(1);
}
