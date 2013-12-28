resources :recurring_tasks

# another way to view recurring tasks
match 'projects/:project_id/recurring_tasks', :to => 'recurring_tasks#index'
match 'projects/:project_id/recurring_tasks/:id', :to => 'recurring_tasks#show'