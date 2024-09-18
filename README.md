# README


### Project Description</br>
In this group project, Little Shop, our team worked on building an E-Commerce application using service-oriented arcitecture, where the back and front ends are separate and communicate via APIs. 

### System Dependencies and Tools</br>
* Ruby version: 3.2.2
* Rails: 7.4.x 
* Database: PostgreSQL 
* Additional Gems: `pry, debug, simplecov, rspec-rails, shoulda-matchers, faker, factory_bot`
* Testing/Sending HTTP requests: Postman

### Essential Setup and Development Commands</br>
* Configuration: `rails new little_shop -T -d="postgresql" --api`
* Database initialization: `rails db:create db:migrate db:seed db:schema:dump`
* Run the test suite: `bundle exec rspec`
* Run your development server: `rails s`
<div style="line-height: 1;">

### Learning Goals</br>
* Use ActiveRecord and SQL to write queries that deal with one-to-many database relationships
* Expose API endpoints to CRUD database resources
* Validate models and handle sad paths for invalid data input
* Test both happy and sad path functionality based on JSON contracts
* Use MVC to organize code effectively, lmiting data logic in controllers and serializers
* Time Management
* Breaking down large project into small pieces
* Breaking down a problem into small steps
* Practice individual research (reading documentation, articles, videos, mentors)

### Contributors</br>


</div>
![Schema Diagram](screenshot_2024-09-10_at_6.38.01___pm_720.png)