
extends TextureProgress

export(int) var pixel_offset = 4

func set_score(val):
	var w = get_size().x
	var val_per_pixel = get_max()/w
	var rel = (pixel_offset*2)*val_per_pixel
	val *= (1-rel/1000)
	val += pixel_offset*val_per_pixel
	set_value(val)

