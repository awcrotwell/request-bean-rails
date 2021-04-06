  # frozen_string_literal: true

class RequestsController < ApplicationController
  before_action :set_request, only: %i[show edit update destroy]
  skip_before_action :verify_authenticity_token
  skip_before_action :authorized, only: %i[log_request]

  # GET /requests/1 or /requests/1.json
  def show; end

  # DELETE /requests/1 or /requests/1.json
  def destroy
    bin_url = @request.bin.url

    @request.destroy
    respond_to do |format|
      format.html do
        redirect_to "/bins/#{bin_url}",
                    notice: 'Request was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def log_request
    bin = Bin.find_by({ url: request.params['bin_url'] })
    @incoming_request = Request.new({
                                      payload: request.raw_post,
                                      bin_id: bin.id,
                                      http_method: request.method
                                    })

    respond_to do |format|
      if @incoming_request.save!
        if !@incoming_request.bin.webhook_url.blank? # TODO: clean up this logic a bit
          RequestForwardingJob.perform_later @incoming_request, bin.webhook_url
        end

        ActionCable.server.broadcast(
          "request_channel_#{bin.url}", @incoming_request
        )

        format.json { render json: {}, status: :created }
      else
        format.json { render json: @bin.errors, status: :unprocessable_entity }
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

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
