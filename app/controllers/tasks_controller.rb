class TasksController < ApplicationController
    before_action :require_user_logged_in, only: [:show, :edit, :new, :create, :update, :destroy]
    before_action :correct_user, only: [:destroy, :show, :edit, :update]
    
    def index
        if logged_in?
        @task = current_user.tasks.build
        @tasks = current_user.tasks.order(id: :desc).page(params[:page])
        else
        redirect_to login_path
        end
        
    end
    
    def show
        @task = Task.find(params[:id])
    end

    def edit
        @task = Task.find(params[:id])
 Rails.logger.info("**********task**********")
 Rails.logger.info(@task.id)
 Rails.logger.info(@task.content)
    end
    
    def new
        @task = Task.new
    end
        
    def create
        @task = current_user.tasks.build(task_params)
        
        if @task.save
            flash[:success] = 'Taskが正常に投稿されました'
            redirect_to root_url
        else
            @tasks = current_user.tasks.order(id: :desc).page(params[:page])
            flash.now[:danger] = 'Taskが投稿されませんでした'
            render 'tasks/new'
        end
    end
    
    def update
        if @task.update(task_params)
            flash[:success] = 'Taskは正常に更新されました'
            redirect_to @task
        else 
            flash.now[:danger] = 'Taskは更新されませんでした'
            render :edit
        end            
    end

    def destroy
        @task.destroy
        flash[:success] = 'メッセージを削除しました。'
        redirect_back(fallback_location: root_path)
    end
    
    private
    

    
    #Storng Paramater
    def task_params
        params.require(:task).permit(:content, :status)
    end

def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
end
    

    
end
