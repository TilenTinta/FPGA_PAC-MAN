VHDL PacMan
-Poročilo
-Project arhive


- Vse 4 tipke (assembly) - X
- labirint (slika 800x600) - building blocks(20x20) * (28x30) = (560x600) - 120 na usaki strani
- pacman (tri slike usta)
- colision
- tocke
- bonus (da jih poje)


dva counterja:
- x_block_cnt
- y_block_cnt
- x_maze_location
- y_maze_location

maze[]
block[] - teh je več

x_block_cnt <= x_block_cnt + 1; -- premikanje po bloku
if x_block_cnt > 20 then -- reset blok stevca
	x_block_cnt <= 0;
	x_maze_location <= x_maze_location + 1; - zamik na naslednjo lokacijo labirinta
	if x_maze_location > 40 then - konec krtice (labirint)
		x_maze_location <= 0; -- reset vrstice
		y_block_cnt <= y_block_cnt + 1; -- premik v naslednjo vrstico bloka
		y_maze_location <= y_maze_location + 1; -- premik v naslednjo vrstico labirinta
		if y_block_cnt > 20 then -- reset y v bloku
			y_block_cnt <= 0;
		end if;
		if y_maze_location > 30 then -- reset y vrstic labirinta
			y_maze_location <= 0;
		end if;
	end if;	
end if

if y_block_cnt > 20 then
	y_block_cnt <= 0;
end if;

