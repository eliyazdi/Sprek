// Light syntax cleanup from https://gist.github.com/daehn/f17e8cdcf8d91b046f3c
import Foundation

class Levenshtein{
    static func levDis(_ w1: String, _ w2: String) -> Int {
        
        let (t, s) = (w1, w2)
        
        let empty = Array<Int>(repeating:0, count: s.count)
        var last = [Int](0...s.count)
        
        for (i, tLett) in t.enumerated() {
            var cur = [i + 1] + empty
            for (j, sLett) in s.enumerated() {
                cur[j + 1] = tLett == sLett ? last[j] : min(last[j], last[j + 1], cur[j])+1
            }
            last = cur
        }
        return last.last!
    }
}
