import UIKit

//Priority Inversion
enum Color: String {
    case red = "red"
    case blue = "blue"
    case green = "green"
}
 
func show(color: Color, count: Int) {
    for _ in 1...count {
        print(color.rawValue)
    }
}
 
let userInteractiveQueue = DispatchQueue.global(qos: .userInteractive)
let utilityQueue = DispatchQueue.global(qos: .utility)
let backgroundQueue = DispatchQueue.global(qos: .background)
let count = 5
 
 
DispatchQueue.main.async {
    
    utilityQueue.async {
        show(color: .green, count: count)
    }
    backgroundQueue.async {
        show(color: .blue, count: count)
    }
    userInteractiveQueue.async {
        show(color: .red, count: count)
    }
    //sync
    backgroundQueue.sync {
        show(color: .blue, count: count)
    }
}

//hasil
/*
"blue"
"green"
"blue"
"blue"
"blue"
"blue"
"green"
"green"
"green"
"green"
"red"
"red"
"red"
"red"
"red"*/

//Thread Explosion dan Deadlock
let queue = DispatchQueue(label: "Concurrent queue", attributes: .concurrent)
 
for _ in 0..<999 {
    queue.async {
        sleep(1000)
    }
}
 
DispatchQueue.main.sync {
    queue.sync {
        print("Done")
    }
}

//Race Condition
let concurrent = DispatchQueue(label: "com.dicoding.racecondition", attributes: .concurrent)
 
var array = [1, 2 ,3 ,4, 5]
 
func race() {
    concurrent.async {
        for i in array { // read access
            print(i)
        }
    }
 
    concurrent.async {
        for i in 0..<10 {
            array.append(i) // write access
        }
    }
}
 
for _ in 0...5 {
    race()
}
/*
1
1
4
0
0
2
1
0
3
1
Concurrency(17809,0x70000a800000) malloc: *** error for object 0x7fc20f204190: pointer being freed was not allocated
Concurrency(17809,0x70000a800000) malloc: *** set a breakpoint in malloc_error_break to debug
4
0
1
2
5
0
1
*/


