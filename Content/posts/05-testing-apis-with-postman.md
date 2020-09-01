---
date: 2020-08-31 22:12
description: Learn to test your API endpoints effectively using Postman.
tags: API, Postman
---
# Using Postman to test your API endpoints

<div class="post-tags" markdown="1">
        <a class="post-category post-category-api" href="/tags/api">API</a>
        <a class="post-category post-category-postman" href="/tags/postman">Postman</a>
</div>


### Introduction
Once you start using APIs in your app you'll quickly realize that it becomes very cumbersome to start your app and manually test it on a real device or simulator every time. It takes more resources as well as extra time. For smaller projects, this may not be an issue at all, but as your apps grow increasingly larger so will your desire to separate pieces of your app into more manageable tests.

While there are multiple options for testing APIs, [Postman](https://www.postman.com) is often recommended because it is easy to use, has great documentation, and is free. Give it a download [here](https://www.postman.com/downloads/) and let's get to testing!

### Testing a basic endpoint
Once you finish downloading Postman and opening it up, you'll see something similar to this.

<img class="post-image" src="/Images/Posts/05/05-01.png" alt="Postman home app" width="800"/>

Let's start with a simple request. [Here](https://alexwohlbruck.github.io/cat-facts/docs/) is a website that will allow us to get free cat facts. *Disclaimer: I have not read all of these and do not attest that they are in fact, facts*. The endpoint is very simple and doesn't even require authorization. Create a new request in Postman by clicking the "+" button, then type in `https://cat-fact.herokuapp.com/facts` for the url and set it as a GET. When you press send you should a JSON return with a handful of cat facts!

<img class="post-image" src="/Images/Posts/05/05-02.png" alt="Cat facts" width="800"/>

### Adding paramaters
For this next example, we are going to use a free API provided by NASA. The endpoint `https://api.nasa.gov/techtransfer/patent/` will return a list of patents and software from NASA that are free for the public to search through. However, when you repeat the above steps you'll see that you actually get an error.


<img class="post-image" src="/Images/Posts/05/05-03.png" alt="Postman home app" width="800"/>

This is because, like most other APIs, this endpoint requires an API key that identifies who you are and tracks your requests. Luckily, we can actually use NASA's demo key here or you can sign up for a free one at [https://api.nasa.gov](https://api.nasa.gov). If you want to use the demo key, it's simply `DEMO_KEY`.

Let's add the demo key now in Postman. Under where you type in your url you'll see a list of different tabs. Click the one that says `Params` and you'll see some boxes to type in `KEY`, `VALUE`, and a `DESCRIPTION`. Let's go ahead and a key of `api_key` with a value of `DEMO_KEY`. You'll notice two changes here. The first is your url you typed in automatically updated to `https://api.nasa.gov/techtransfer/patent/?api_key=DEMO_KEY`. This is nice because it formats it for you how it needs to be, but it's easier for you to see the parameters separated below. Sure, it's not a problem with one parameter like this one, but it can get excessive! The second thing you'll notice is that You actually get results back when you click `Send`. 

<img class="post-image" src="/Images/Posts/05/05-04.png" alt="Postman home app" width="800"/>

### Adding multiple parameters
Adding more than one parameter is as simple as adding new key values in the `Params` section. Let's filter our results to contain only software that has something to do with Mars. Add the key `software` with the value `mars`. Your results will only get back data the word `mars` in it now! *Note - the data is not perfect. You'll also get results that contain the word Marshall since that contains the word mars in itself*.

Try playing with the other parameter options and see what you can come up with. 

<img class="post-image" src="/Images/Posts/05/05-05.png" alt="Postman home app" width="800"/>

### Sending POST requests
Up until now, we have only made GET requests, which means you are just trying to retrieve data from somewhere. However, if we want to *send* data to someone else we can use something like a POST HTTP method. POST methods are often used with submitting information somewhere, such as in a form on the web. The data may be sensitive, so you won't be able to bookmark it or cache it. Let's test some POST methods by using Postmans' own test endpoints. Try sending a request to `https://postman-echo.com/post`, but changing your method from GET to POST now.

You should see some information return, including an empty data section.

<img class="post-image" src="/Images/Posts/05/05-06.png" alt="Postman basic POST request" width="800"/>

However, I now want you to navigate to the `body` section under where you type in the url, select `raw` and change `text` to `JSON`. Then add the following information.

```
{
  "title": "Did you put your name in the Goblet of Fire, Harry",
  "body": "he asked calmly"
}
```

When you run the request now you'll see that you get data back.

You can get as complicated as you want with the data you send in, just make sure it matches what the server is looking for on the other end!

```
[
  {
    "quotes": [
      {
        "title": "Did you put your name in the Goblet of Fire, Harry",
        "body": "he asked calmly"
      },
      {
        "title": "Po-tay-toes",
        "body": "Boil 'em, mash 'em, stick 'em in a stew."
      }
    ]
  }
]
```

<img class="post-image" src="/Images/Posts/05/05-08.png" alt="Postman POST request with more data" width="800"/>


Although we didn't go over any Swift code in this tutorial, I hope you learned something valuable that will help you in the future.
