# Books App / Take Home

### The architectural design
I chose MVVM for the application's view tier, alongside single-responsibility and dependency injection principles for everything else. The reasons behind those choices were:

- I wanted to showcase (as much as possible) the kind of work I'm used to do;
- I believe these are current industry standards / best practices widely adopted.

For consuming the Open Books REST API, I've created `BookAPIService` and `BookCoverAPIService`. Each one create their corresponding GET HTTP request, deal with possible failure scenarios and return their correspondent decoded models on success. 

The `BookCoverAPIService` caches the downloaded thumbnails in memory for saving networking resources and proving a great browsing experience.

I've created a small utility class, `ErrorLogger`, which could easly be connected to an external logging service like Crashlytics for logging non-fatal exceptions. 

I've chose not to implement data persistence at this time. I didn't believe storing a search result would be a real world case scenario and implementing an additional feature would take more time than those 4 hours I was expected to respect.  

### 3rd party libraries
I'm a big advocate of **avoiding as much as possible** adopting 3rd-party libraries, but these ones I carry with me in my toolbox:

- `Realm`: I'm very passionate about this Core Data replacement because it's more powerful, simpler to use and maintain, and makes it super easy to adopt reactive programing. I havent had the opportunity to use it at this time, though.
- `Quick, Nimble`: unit test frameworks that, in my opinion, bring a lot more to the table than XCTest framework.
- `Cuckoo`: nice and easy to use mocking framework for complementing the previous two frameworks;
- `OKHTTPStubs`: powerful and simple framework for stubbing HTTP requests and dramatically simplifying development, since it's no longer necessary to inject `URLSession` or other similar dependencies. 

### Book search
These are the main functionalities:

1. allows the user to search for books by using keywords;
2. presents a list of matching books identified by title, author and cover (thumbnail);
3. limits the results to 10 and displays the total number of works found;
4. covers case scenarios where no results are found;

Some UI / UX system features supported:

- light / dark theme;
- dynamic fonts (accessibility);

### The trade-offs
These were the limitations imposed due to time constraints:

1. Device: iPhone only;
2. Orientation: portrait only;
3. Localization: none;
4. Lack of pagination for long results;
5. Lack of features covering local storage; 

In addition, these were the high value areas I chose to put under test:

1. BookAPIService: covers both success and failure scenarios, leveraging OKHTTPStubs framework for stubing HTTP requests.  
2. SearchViewModel: covers the entire flow of communication between view and view-model. 

### How to run the project.
1. Open Books.xcodeproj
2. Pick an iPhone simulator
3. Run

### Additional information.
I wanted to show as much as possible my mindset and passion for creating software, which includes aspects of craftsmanship for writing code, as well as looking into the product from the owner and end user standing points.

I've also simulated a team environment by following Gitflow workflow.
