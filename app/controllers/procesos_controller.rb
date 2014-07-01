class ProcesosController < ApplicationController
  require 'json'
  before_action :check_priority, only: [:prioritize]
  before_action :check_pid, only: [:prioritize,:kill]  
  # GET /procesos
  # GET /procesos.json
  def index
    @procesos = Proceso.all

    render json: @procesos
  end

  # GET /procesos/1
  # GET /procesos/1.json
  

  # POST /procesos
  # POST /procesos.json


  # PATCH/PUT /procesos/1
  # PATCH/PUT /procesos/1.json
  def update
    @proceso = Proceso.find(params[:id])

    if @proceso.update(params[:proceso])
      head :no_content
    else
      render json: @proceso.errors, status: :unprocessable_entity
    end
  end

  # DELETE /procesos/1
  def destroy
    @proceso = Proceso.find(params[:id])
    @proceso.destroy

    head :no_content
  end

  def create_pr
    @proceso = Proceso.create_pr(params[:process][:command])

    if @proceso.errors.empty?
      render json: Proceso.Pr_To_Hash(@proceso), status: :created
    else
      render json: @proceso.errors, status: :unprocessable_entity
    end
  end

  def show_pr
    @proceso = Proceso.find(params[:pid])
    if @proceso
      render json: Proceso.Pr_To_Hash(@proceso), status: :ok
    else
      head :not_found
    end  
  end

  def show_children
    @proceso=Proceso.find(params[:pid])
    @children=@proceso.getChildren
    if @children 
      render json: Proceso.AllPr_To_Hash(@children), status: :ok
    else
      head :no_content
    end
  end

  def list_pr
    @procesos=Proceso.createAllPr
    render json: Proceso.AllPr_To_Hash(@procesos) 
  end

  def kill
    if Proceso.kill(params[:pid])
      head :no_content
    else
      head :not_found
    end
  end 

  def prioritize
    @proceso=Proceso.prioritize(params[:pid],params[:process][:pri])
    if @proceso
      render json: Proceso.Pr_To_Hash(@proceso), status: :ok
    else
      head :not_found
    end
  end

  def check_pid
    unless /\A\d{1,5}\z/.match("#{params[:pid]}")
      head :not_found
    end
  end

  def check_priority
    puts params[:process][:pri]
    unless  /\A(0|((\+|\-)([1-9]|1[0-9]))|\-20)\z/.match("#{params[:process][:pri]}")
      head :not_found
    end
  end

end
