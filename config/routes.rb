resources :projects do
  resources :recurring_tasks
end
# another way to view recurring tasks
#match 'projects/:project_id/recurring_tasks', :to => 'recurring_tasks#index'
#match 'projects/:project_id/recurring_tasks/:id', :to => 'recurring_tasks#show'
match 'recurring_tasks', :to => 'recurring_tasks#index'
