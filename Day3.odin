package AoC_2023

import "core:fmt"
import "core:strings"
import "core:os"
import "core:strconv"
import "core:slice"
import "core:math"
import "core:unicode/utf8"
import "core:unicode"

main :: proc() {
    solution("./AoC Files/Day3.txt")
}

solution :: proc(filepath: string) {
    data, ok := os.read_entire_file(filepath, context.allocator)
    if !ok do return 
    defer delete(data, context.allocator)  

    arr : [dynamic]string
    it := string(data)
    for line in strings.split_lines_iterator(&it) do append(&arr,line)

    Directory :: struct {
        num : int,
        x : int,
        y : int,
        rng : []int
    }

    arr_dir, num_dir : [dynamic]Directory
    defer delete(arr); defer delete(arr_dir); defer delete(num_dir)
    
    for i in 0..<len(arr) {
        str : [dynamic]rune
        tmp_pos : [dynamic]int
        for j in 0..<len(arr) {
            if rune(arr[i][j]) != '.' && ! unicode.is_digit(rune(arr[i][j])) {
                append(&arr_dir, Directory{x = j, y = i})
            } 
            if unicode.is_digit(rune(arr[i][j])) {
                append(&str,rune(arr[i][j]))
                append(&tmp_pos, j)
            }
            if (! unicode.is_digit(rune(arr[i][j])) || j == len(arr) - 1 ) && len(str) > 0 {
                tmp := utf8.runes_to_string(str[:])
                append(&num_dir, Directory{num = strconv.atoi(tmp), x = j-1, y = i, rng = slice.clone(tmp_pos[:])})
                clear(&str)
                clear(&tmp_pos)
            }
        }
    }

    arr_nums : [dynamic]Directory
    gears : [dynamic]int
    defer delete(arr_nums); defer delete(gears)

    for i in arr_dir {
        tmp : [dynamic]int
        for j in num_dir {
            if slice.contains(j.rng,i.x) && (j.y == i.y+1 || j.y == i.y-1) ||
            slice.contains(j.rng,i.x+1) && (j.y == i.y || j.y == i.y-1 || j.y == i.y+1) ||
            slice.contains(j.rng,i.x-1) && (j.y == i.y+1 || j.y == i.y || j.y == i.y-1) {
                append(&arr_nums, Directory{num = j.num, x = j.x, y = j.y})
                append(&tmp,j.num)
            }
        }   
        if len(tmp) == 2 do append(&gears, math.prod(tmp[:]))
    }
    sum, sum2 := 0, 0
    for i in arr_nums do sum += i.num
    for i in gears do sum2 += i
    fmt.printf("Part 1: %v\nPart 2: %v", sum, sum2)
}
