# frozen_string_literal: true

class RequestsController < ApplicationController
  before_action :set_request, only: %i[show edit update destroy]

  # GET /requests/1 or /requests/1.json
  def show; end

  # POST /:bin/requests
  
  # POST /requests or /requests.json
  def create
    @request = Request.new(request_params)


    respond_to do |format|
      if @request.save
        format.html do

          redirect_to @request, notice: 'Request was successfully created.'
        end
        format.json { render :show, status: :created, location: @request }
=begin
check if there's a url associated with this bin
request.body
send body as a post request to the url
=end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: @request.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /requests/1 or /requests/1.json
  def destroy
    @request.destroy
    respond_to do |format|
      format.html do
        redirect_to requests_url, notice: 'Request was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def request_params
      params.require(:request).permit(:payload, :reference)
    end
end
