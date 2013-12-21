match 'recurring_tasks', :to => 'recurring_tasks#index'
match 'recurring_tasks/new', :to => 'recurring_tasks#new'
match 'recurring_tasks/:id/show', :to => 'recurring_tasks#show'
match 'recurring_tasks/:id/edit', :to => 'recurring_tasks#edit'