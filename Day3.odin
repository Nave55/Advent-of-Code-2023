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

    it := string(data)
    arr : [dynamic]string
    arr_dir, num_dir : [dynamic]Directory
    Directory :: struct {
        num : int,
        x : int,
        y : int,
        r : []int
    }
    
    for line in strings.split_lines_iterator(&it) do append(&arr,line)
    
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
            if ! unicode.is_digit(rune(arr[i][j])) && len(str) > 0 || j == len(arr) - 1 && len(str) > 0 {
                tmp := utf8.runes_to_string(str[:])
                append(&num_dir, Directory{num = strconv.atoi(tmp), x = j-1, y = i, r = slice.clone(tmp_pos[:])})
                clear(&str)
                clear(&tmp_pos)
            }
        }
    }

    arr_nums : [dynamic]Directory
    for i in num_dir {
        for k in arr_dir {
            if slice.contains(i.r,k.x+1) && i.y == k.y || slice.contains(i.r,k.x-1) && i.y == k.y || 
            slice.contains(i.r,k.x) && i.y == k.y+1 || slice.contains(i.r,k.x+1) && i.y == k.y+1 ||
            slice.contains(i.r,k.x-1) && i.y == k.y+1 || slice.contains(i.r,k.x) && i.y == k.y-1 ||
            slice.contains(i.r,k.x+1) && i.y == k.y-1 || slice.contains(i.r,k.x-1) && i.y == k.y-1 {
                append(&arr_nums, Directory{num = i.num, x = i.x, y = i.y})
            }
        }
    }
    sum := 0
    for i in arr_nums do sum += i.num

    gears : [dynamic]int
    for k in arr_dir {
        tmp : [dynamic]int
        for i in num_dir {
            if slice.contains(i.r,k.x+1) && i.y == k.y || slice.contains(i.r,k.x-1) && i.y == k.y || 
            slice.contains(i.r,k.x) && i.y == k.y+1 || slice.contains(i.r,k.x+1) && i.y == k.y+1 ||
            slice.contains(i.r,k.x-1) && i.y == k.y+1 || slice.contains(i.r,k.x) && i.y == k.y-1 ||
            slice.contains(i.r,k.x+1) && i.y == k.y-1 || slice.contains(i.r,k.x-1) && i.y == k.y-1 {
                append(&tmp,i.num)
            }
        }   
        if len(tmp) == 2 do append(&gears, math.prod(tmp[:]))
    }

    sum2 := 0
    for i in gears do sum2 += i
    fmt.printf("Part 1: %v\nPart 2: %v", sum, sum2)
}
