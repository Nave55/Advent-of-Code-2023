import haxe.macro.Expr;
import haxe.Int64;
import Std.*;
using Lambda;
using hx.strings.Strings;

typedef AS = Array<String>;
typedef AI = Array<Int>;
typedef AF = Array<Float>;
typedef AAS = Array<Array<String>>;
typedef AAI = Array<Array<Int>>;
typedef AAF = Array<Array<Float>>;
typedef AAAS = Array<Array<Array<String>>>;
typedef AAAI = Array<Array<Array<Int>>>;
typedef AAAF = Array<Array<Array<Float>>>;
typedef MII = Map<Int,Int>;
typedef MSI = Map<String,Int>;
typedef MIS = Map<Int,String>;
typedef MSS = Map<String,String>;
typedef MI64 = Map<Int, Int64>;
typedef MS64 = Map<String,Int64>;

macro function swap(a:Expr, b:Expr) {
    return macro {var v = $a; $a = $b; $b = v;};
}

function intSum(arr: Array<Int>):Int {
    var ttl = 0;
    for (i in arr) ttl += i;
    return ttl;
}

function floatSum(arr: Array<Float>):Float {
    var ttl:Float = 0;
    for (i in arr) ttl += i;
    return ttl;
}

function binaryToDecimal(str: String): String {
    var iter = str.length - 1;
    var dec = 1, ttl = 0;
    while (iter >= 0) {
        if (str.charAt(iter) == '1') ttl += dec;
        dec *= 2;
        --iter;
    }
    return string(ttl);
}

function decimalToBinary(num: Int): String {    
    var strs: String = ""; 
    while (num > 0) {
        if (num & 1 == 1) strs += "1";
        else strs += "0";
        num >>= 1;
    }
    return strs.reverse();
}

function alphabetSort(str: String): String {
    var arr: AI = [];
    var sort_str = "";
    for (i in 0...str.length) arr.push(str.charCodeAt(i));
    arr.sort((a,b) -> a - b);
    for (i in arr) sort_str += i.toChar();
    return sort_str;
}