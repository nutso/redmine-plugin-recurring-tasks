# resources :recurring_tasks

# admin view
match 'recurring_tasks', :to => 'recurring_tasks#index'

# project view 
match 'projects/:project_id/recurring_tasks', :to => 'recurring_tasks#index', :as => :recurring_tasks
match 'projects/:project_id/recurring_tasks/new(/:issue_id)', :to => 'recurring_tasks#new', :as => :new_recurring_task
match 'projects/:project_id/recurring_tasks/create', :to => 'recurring_tasks#create'
match 'projects/:project_id/recurring_tasks/:id/edit', :to => 'recurring_tasks#edit', :as => :edit_recurring_task
match 'projects/:project_id/recurring_tasks/:id/update', :to => 'recurring_tasks#update'
match 'projects/:project_id/recurring_tasks/:id/destroy', :to => 'recurring_tasks#destroy', :as => :destroy_recurring_task
