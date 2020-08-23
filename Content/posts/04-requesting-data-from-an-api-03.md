---
date: 2020-08-22 22:12
description: Part 3 of using Alamofire to make an API request. This part closes out this tutorial by showing you how to handle errors.  
tags: API, Alamofire, ErrorHandling
---
# Use Alamofire to make an API request for NASA's Astronomy Picture of the Day - Part 3

<div class="post-tags" markdown="1">
        <a class="post-category post-category-api" href="/tags/api">API</a>
        <a class="post-category post-category-alamofire" href="/tags/alamofire">Alamofire</a>
        <a class="post-category post-category-errorhandling" href="/tags/errorhandling">Error Handling</a>
</div>

<table class="posts-table">
    <tr>
        <th class="th-singl-left"><a href="/posts/04-requesting-data-from-an-api-02" style="text-decoration: none">&larr; Making the request</a></th>
    </tr>
</table>


### Handling Errors
As I've said before, sometimes NASA's API doesn't return us any data. This is not unique to NASA API's. Anything could happen online that you have no control over. However, you do have control over what happens if your app runs into the error. Instead of letting your app crash, let's explain to the user what's happening. 

During decoding, Alamofire returns a response. This response may or may not have an error attached to it. We can place in a check to see if the response contains an error or not and act appropriately. We will do something simple here by just updating our title label with a message saying an error has occured, please try again later. It's not perfect, but it's your job to figure out why there is an error in the first place. Then you can handle each case uniquely.

Add the following function: 

```
func errorOccurred() {
    titleLabel.text = "An error occurred. No data could be found. Please try again later"
    titleLabel.numberOfLines = 0
}
```

Then update your fetchAPOD() to look like this:

```
func fetchAPOD() {
    let request = AF.request(apiURL + APIKey)
    request.responseDecodable(of: APOD.self) { response in
        
        guard response.error == nil else {
            self.errorOccurred()
            
            return
        }
        
        guard let apod = response.value else { return }
        
        self.loadDetails(apod: apod)
        self.loadImage(urlString: apod.url)
    }
}
```

Now you should see a nice message show up instead of a blank screen or crash. The easiest way to test this at this point in time is to update your url to be incorrect.  Run your code and your app should now look like this:

<img class="post-image img-md" src="/Images/Posts/04/04-06.png" alt="API Request Data and Image" width="800"/>

That's realy all there is too it! In other tutorials we can take a look at more advanced topics for making API requests. If you'd like to see the full source code for this project you can check it out [here](https://github.com/thomaskellough/iOS-Tutorials-UIKit-Swift/tree/master/APOD).

<table class="posts-table">
    <tr>
        <th class="th-singl-left"><a href="/posts/04-requesting-data-from-an-api-02" style="text-decoration: none">&larr; Making the request</a></th>
    </tr>
</table>
