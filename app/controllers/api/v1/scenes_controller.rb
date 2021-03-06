class Api::V1::ScenesController < ApplicationController
  before_action :set_scene, only: [:show, :edit, :update, :destroy]
  def show
    if authorized?
      render json: SceneSerializer.new(@scene).serialized_json
    else
      render json: { error: 'not authorized' }, status: 401
    end
  end

  def create
    scene = script.scenes.new(scene_params)
    if no_error?(scene)
      if scene.save
        render json: SceneSerializer.new(scene).serialized_json
      else
        render json: { error: scene.errors.messages }, status: 422
        # render json: { error: scene.errors.messages[:name] }, status: 423
      end
    else
      render json: { error: "Custom message - name must be unique" }, status: 422
      # render json: { status: "error", code: 4000, message: "item_id is required to make a purchase" }
      # render json: 'Name needs to be unique'.to_json
    end
  end

  def destroy
    scene = Scene.find(params[:id])

    if scene.destroy
      head :no_content
    else
      render json: { error: scene.errors.messages }, status: 422
    end
  end

  private

  def no_error?(scene)
    true
    # Scene.where(name: scene.name, script_id: scene.script_id).empty?
  end

  def authorized?
    @scene.script.user == current_user
  end

  def set_scene
    @scene = Scene.find(params[:id])
  end

  def script
    @script = Script.find(params[:script_id])
  end

  def scene_params
    params.require(:scene).permit(:number, :name, :description, :body, :mood, :set, :notes, :play_day)
  end
end
