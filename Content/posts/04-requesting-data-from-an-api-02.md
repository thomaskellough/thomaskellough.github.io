---
date: 2020-08-21 22:12
description: Part 2 of using Alamofire to make an API request. This part focuses on creating your model, making the request, and updating your app with your results.
tags: API, Alamofire, Models, DispatchQueue, Codable
---
# Use Alamofire to make an API request for NASA's Astronomy Picture of the Day - Part 2

<div class="post-tags" markdown="1">
        <a class="post-category post-category-api" href="/tags/api">API</a>
        <a class="post-category post-category-alamofire" href="/tags/alamofire">Alamofire</a>
        <a class="post-category post-category-models" href="/tags/models">Models</a>
        <a class="post-category post-category-dispatchqueue" href="/tags/dispatchqueue">DispatchQueue</a>
        <a class="post-category post-category-codable" href="/tags/codable">Codable</a>
</div>

<table class="posts-table">
    <tr>
        <th class="th-left"><a href="/posts/04-requesting-data-from-an-api-01" style="text-decoration: none">&larr; Introduction and setting up</a></th>
        <th class="th-middle"></th>
        <th class="th-right"><a href="/posts/04-requesting-data-from-an-api-03" style="text-decoration: none">Handling errors &rarr;</a></th>
    </tr>
</table>

### Creating our model

Before we start making our API request, we need to create a model to store our data nicely. Recall how the data looks when it's returned to us. We need to create a struct that holds a property for each piece of data returned and also have the struct conform to Decodable so we can convert it from the JSON object. Go ahead and create a new swift file called `APODmodel.swift` and add the following code:

```
struct APOD: Decodable {
    let title: String
    let date: String
    let explanation: String
    let hdurl: String
    let url: String
    let copyright: String?
}
```

Note that copyright is optional because we may or may not get that back during our request. If we left it as nonoptional then your app would crash on most days. This model allows us to call out the title, date, explanation, or two different types of images that we can download. For this project, we will just be using the basic url and not the hdurl (high definition) because it can be much slower to process. 

### Making an API Request
Great! Let's finally start digging into our code in order to make our first API request. You'll be amazed by how easy it is to make an API request and decode it using Alamofire and codable. Add this function to `ViewController.swift` and call it in `viewDidLoad()`:

```
func fetchAPOD() {
    let request = AF.request(apiURL + APIKey)
    request.responseDecodable(of: APOD.self) { response in
        guard let apod = response.value else { return }
    }
}
```

Seriously, it's that easy! First Alamofire makes a request using the api endpoint you provided and your specific api key. Then, it takes that result and matches it to the model you created to give you an APOD object. Although, running your code right now won't show you anything of value yet. We haven't done anything with the data. 

### Updating our UI
We need to do two different things to update our UI with the data that is returned. Let's start with the easy part, which is updating each label in our stackview appropriately. Let's create a function that does the following things:

1) Takes in an APOD object as a parameter

2) Updates the dateLabel/titleLabel/explanationLabel with the data from our APOD object passed in

3) Allow each label to expand to show as many lines as it needs by setting the property `label.numberOfLines=0`

4) Give each label a custom font that can size dynamically and a custom color of our choosing

5) If we get a copyright back, update the label for that, otherwise, hide the label

```
func loadDetails(apod: APOD) {
    dateLabel.text = apod.date
    dateLabel.numberOfLines = 0
    dateLabel.font = .preferredFont(forTextStyle: .callout)
    dateLabel.adjustsFontForContentSizeCategory = true

    titleLabel.text = apod.title
    titleLabel.textColor = .systemGreen
    titleLabel.numberOfLines = 0
    titleLabel.font = .preferredFont(forTextStyle: .title1)
    dateLabel.adjustsFontForContentSizeCategory = true

    explanationLabel.text = apod.explanation
    explanationLabel.numberOfLines = 0
    explanationLabel.font = .preferredFont(forTextStyle: .body)
    explanationLabel.adjustsFontForContentSizeCategory = true
    
    if let copyright = apod.copyright {
        copyrightLabel.text = "Copyright: \(copyright)"
        copyrightLabel.numberOfLines = 0
        copyrightLabel.font = .preferredFont(forTextStyle: .caption1)
    } else {
        copyrightLabel.isHidden = true
    }
}
```
Now you can call your function in the closure of your api request. Add the following line:

```
self.loadDetails(apod: apod)
```

That's all it takes to update your labels! You should be able to run your code now and see everything except for the image. Remember, if you don't see anything check your API request in Postman or just copy and paste it into a web browser and see what data returns.

<img class="post-image" src="/Images/Posts/04/04-04.png" alt="API Request Data Only" width="800"/>


### Updating our image
Loading an image from a url isn't as difficult is it may sound. Here are the steps to make it happen:

1) Create a function that takes in a url string as a parameter. We get this from `apod.url`

2) Create a url object from our url string passed in

3) Using DispatchQueue, try and create a data object out of the contents of our url

4) Try and create an image our of our data object

5) Update our image view with our image using the main thread

The code looks like this:

```
func loadImage(urlString: String) {
    guard let url = URL(string: urlString) else { return }

    DispatchQueue.global().async { [weak self] in
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
        }
    }
}
```

Then inside your API request closure, you can add 

```
self.loadImage(urlString: apod.url)
```

Just to update, your entire `fetchAPOD()` function should now look like this

```
func fetchAPOD() {
    let request = AF.request(apiURL + APIKey)
    request.responseDecodable(of: APOD.self) { response in
        guard let apod = response.value else { return }
        
        self.loadDetails(apod: apod)
        self.loadImage(urlString: apod.url)
    }
}
```

Awesome! Restart your app and see your new picture!

<img class="post-image img-md" src="/Images/Posts/04/04-05.png" alt="API Request Data and Image" width="800"/>

<table class="posts-table">
    <tr>
        <th class="th-left"><a href="/posts/04-requesting-data-from-an-api-01" style="text-decoration: none">&larr; Introduction and setting up</a></th>
        <th class="th-middle"></th>
        <th class="th-right"><a href="/posts/04-requesting-data-from-an-api-03" style="text-decoration: none">Handling errors &rarr;</a></th>
    </tr>
</table>
