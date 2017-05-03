# unID

Welcome to the unID git repository!

## Routes and pages

To begin with, we are not putting in any user search functionality, so we willnot have a users#index controller or route. If we do include a way for users tosearch other users, it will be through the APIs of the individual social networks.

These are the routes as defined so far:
```
   Prefix Verb   URI Pattern                    Controller#Action
     root GET    /                              users#new
    cards POST   /:_id/cards(.:format)          cards#create
 new_card GET    /:_id/cards/new(.:format)      cards#new
edit_card GET    /:_id/cards/:id/edit(.:format) cards#edit
     card PATCH  /:_id/cards/:id(.:format)      cards#update
          PUT    /:_id/cards/:id(.:format)      cards#update
          DELETE /:_id/cards/:id(.:format)      cards#destroy
   _index POST   /                              users#create
     edit GET    /:id/edit(.:format)            users#edit
          GET    /:id(.:format)                 users#show
          PATCH  /:id(.:format)                 users#update
          PUT    /:id(.:format)                 users#update
          DELETE /:id(.:format)                 users#destroy
```
The get requests are to root (users#new), to an individual users page, possibly to an individual users card.
The users#edit, cards#edit, cards#new get requests will require the correct user to be logged in, as will all of the post, put, patch, and delete routes.

There is no cards#index route, because this behaviour will be handled by the users#show controller. I also got rid of the redundant /new route, so somebody can call themselves "new" if they really want to, although we will probably reserve additional key words.

*NOTE:* as we need to add new routes, all of them *MUST* be added at the top of routes.rb, since we can't predidct what ids will be passed.
