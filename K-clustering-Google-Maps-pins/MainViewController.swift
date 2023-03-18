//
//  ViewController.swift
//  Task2
//
//  Created by seyedali hamedi on 3/18/23.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(optimizingKClusterin(maximumIterations:10,k:3,data:[(lat:35.700,lon:57.500),(lat:12.200,lon:98.01),(lat:98.90,lon:12.34),(lat:34.65,lon:45.76),(lat:76.77,lon:9.99),(lat:81.23,lon:65.47),(lat:05.55,lon:56.55),(lat:50.12,lon:45.00)]))
        
    }
    
    func kClustringAlgorithm(k:Int,data:[(lat:Double,lon:Double)])-> [[(Double,Double)]]{
        
        // Shuffle data to select random values
        var shuffeld = data.shuffled()
        
        // Select random numbers from copied and shuffled array
        // And deleted the selected item to avoid subscription
        var selectedNumbers:[(Double,Double)] = []
        for _ in 0...k-1 {
            let rand1 = shuffeld.randomElement()!
            shuffeld.removeAll(where: {$1 == rand1.lon && $0 == rand1.lat})
            selectedNumbers.append(rand1)
            
        }
        
        // Initilize output which is a 2d array with the size of k * unkonwn and the total count is data.count
        var output:[[(Double,Double)]] = []
        for _ in 0...k-1 {
            output.append([])
        }
    
        // Going Through the whole data and compare each data with all of the randomly selected balue
        // and append the data to the section of output related to the minimum diffrence
        for i in 0...data.count-1{
            var min = calcDistance(first: selectedNumbers[0] ,second: data[i])
            var minClusterIndex = 0
            for j in 0...k-1 {
                if(min >  calcDistance( first: selectedNumbers[j] ,second: data[i])){
                    min = calcDistance( first: selectedNumbers[j] ,second: data[i])
                    minClusterIndex = j
                }
            }
            output[minClusterIndex].append(data[i])
        }
        return output
    }
    
    func optimizingKClusterin(maximumIterations:Int,k:Int,data:[(lat:Double,lon:Double)]) ->[[(Double,Double)]]{
        
        var optimizedResults = kClustringAlgorithm(k: k, data: data)
        var varianceOfThisIteration = calcVarianceOfIteration(results:optimizedResults)
        for _ in 0...maximumIterations-1{
          let results = kClustringAlgorithm(k: k, data: data)
            if(varianceOfThisIteration > calcVarianceOfIteration(results: results)){
                varianceOfThisIteration = calcVarianceOfIteration(results: results)
                optimizedResults = results
            }
           
        }
        return optimizedResults
    }
    
    func calcDistance(first:(lat:Double,lon:Double),second:(lat:Double,lon:Double))->Double{
        // fromula for distance by  latitude and longitude
        
        let exp = acos(sin(first.lat)*sin(second.lat)+cos(first.lat)*cos(second.lat)*cos(second.lon-first.lon))*6371
        return exp
    }
    
    func calcVarianceOfIteration(results:[[(Double,Double)]])->Double{
        
        var numberOfElementsInEachCluster:[Int] = []
        
        // Get the number of elements in each cluster and calculate the variance
        for arr in results{
            numberOfElementsInEachCluster.append(arr.count)
        }
        let variance = variance(arr:numberOfElementsInEachCluster)
        
        return variance
    }

    func variance(arr:[Int])->Double{
        //Vaiance Forumla ; Simple math :)
        var sum = 0
        var SD = 0.0
        var S = 0.0
       
        // Calculating the mean
        for x in 0..<arr.count{
           sum += arr[x]
        }
        let mean = sum/arr.count
       
        // Calculating Variance
        for y in 0..<arr.count{
           SD += pow(Double(arr[y] - mean), 2)
        }
        S = SD/Double(arr.count)
    
        return S
       
    }


    
}
