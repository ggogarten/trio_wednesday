require './alchemyapi.rb'

class ConceptsController < ApplicationController
  before_action :set_concept, only: [:show, :edit, :update, :destroy]

  # GET /concepts
  # GET /concepts.json
  def index
    @concepts = Concept.all
  end

  # GET /concepts/1
  # GET /concepts/1.json
  def show
  end

  # GET /concepts/new
  def new
    @concept = Concept.new
  end

  # GET /concepts/1/edit
  def edit
  end

  # POST /concepts
  # POST /concepts.json
  def create
    @concept = Concept.new(concept_params)

    respond_to do |format|
      if @concept.save
        format.html { redirect_to @concept, notice: 'Concept was successfully created.' }
        format.json { render :show, status: :created, location: @concept }
      else
        format.html { render :new }
        format.json { render json: @concept.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /concepts/1
  # PATCH/PUT /concepts/1.json
  def update
    respond_to do |format|
      if @concept.update(concept_params)
        format.html { redirect_to @concept, notice: 'Concept was successfully updated.' }
        format.json { render :show, status: :ok, location: @concept }
      else
        format.html { render :edit }
        format.json { render json: @concept.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /concepts/1
  # DELETE /concepts/1.json
  def destroy
    @concept.destroy
    respond_to do |format|
      format.html { redirect_to concepts_url, notice: 'Concept was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def connect
    key = 'be2d1daed89556039d606f9062dcef7983146537'
    alchemyapi = AlchemyAPI.new(key)

    demo_text = "The Declaration of Independence is the statement adopted by the Continental Congress meeting at Philadelphia."

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
  def set_concept
    @concept = Concept.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def concept_params
    params.require(:concept).permit(:idea, :relevance, :speech_id)
  end
end
