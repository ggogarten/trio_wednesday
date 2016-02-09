class SpeechesController < ApplicationController
  before_action :set_speech, only: [:show, :edit, :update, :destroy, :connect]

  # GET /speeches
  # GET /speeches.json
  def index
    @speeches = Speech.all
  end

  # GET /speeches/1
  # GET /speeches/1.json
  def show
  end

  # GET /speeches/new
  def new
    @speech = Speech.new
  end

  # GET /speeches/1/edit
  def edit
  end

  # POST /speeches
  # POST /speeches.json
  def create
    @speech = Speech.new(speech_params)

    respond_to do |format|
      if @speech.save
        format.html { redirect_to @speech, notice: 'Speech was successfully created.' }
        format.json { render :show, status: :created, location: @speech }
      else
        format.html { render :new }
        format.json { render json: @speech.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /speeches/1
  # PATCH/PUT /speeches/1.json
  def update
    respond_to do |format|
      if @speech.update(speech_params)
        format.html { redirect_to @speech, notice: 'Speech was successfully updated.' }
        format.json { render :show, status: :ok, location: @speech }
      else
        format.html { render :edit }
        format.json { render json: @speech.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /speeches/1
  # DELETE /speeches/1.json
  def destroy
    @speech.destroy
    respond_to do |format|
      format.html { redirect_to speeches_url, notice: 'Speech was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def connect
    key = 'be2d1daed89556039d606f9062dcef7983146537'
    alchemyapi = AlchemyAPI.new(key)

    demo_text = @speech.text

    puts ''
    puts ''
    puts ''
    puts '############################################'
    puts '#  Concept Tagging Example                 #'
    puts '############################################'
    puts ''
    puts ''

    puts 'Processing text: ' + demo_text
    puts ''

    response = alchemyapi.concepts('text', demo_text)

    if response['status'] == 'OK'
      puts '## Response Object ##'
      puts JSON.pretty_generate(response)


      puts ''
      puts '## Concepts ##'
      for concept in response['concepts']
        puts 'text: ' + concept['text']
        puts 'relevance: ' + concept['relevance']
        puts ''
        i = Concept.new
        i.speech = @speech
        i.idea = concept['text']
        i.relevance = concept['relevance']
        i.save
      end
    else
      puts 'Error in concept tagging call: ' + response['statusInfo']
    end
    # redirect_to concept_path
    index()
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_speech
      @speech = Speech.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def speech_params
      params.require(:speech).permit(:date, :text, :candidate_id)
    end
end
