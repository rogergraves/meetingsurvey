module SurveyHelper
  def yes_or_no_survey(question, uid)
    question_id = "question_#{uid}"
    answer_id = "answer_#{uid}"
   
    %Q(
      <div id=#{question_id} class="question text-center">
        <h3>#{question}</h3>
        #{hidden_field_tag question_id, question}
        <div class="buttons">
          <label class="btn btn-lg btn-yes" for="#{answer_id}_yes">
            <input type="radio" name="#{answer_id}" id="#{answer_id}_yes" autocomplete="off"><i class='fa fa-thumbs-o-up'></i>
            <div class="text-input-legend">y</div>
          </label>
          <label class="btn btn-lg btn-no for="#{answer_id}_no">
            <input type="radio" name="#{answer_id}" id="#{answer_id}_no" autocomplete="off"><i class='fa fa-thumbs-o-down'></i>
            <div class="text-input-legend">n</div>
          </label>
        </div>
        <textarea class="why" cols="30" rows="1" placeholder="Have some comments?" id="#{answer_id}_why"></textarea>
        <div class="text-center button-block">
          <a href="#" role="button" class="btn btn-default btn-lg btn-continue" id="#{answer_id}_next">
            <i class='fa fa-check'></i> Next
          </a>
          <br>
          <span class="hotkey">SHIFT + ENTER</span>
        </div>
      </div>
    ).html_safe
  end

  def text_survey(question, uid)
    question_id = "question_#{uid}"
    answer_id = "answer_#{uid}"
    %Q(
      <div id=#{question_id} class='question text-center'>
        #{hidden_field_tag question_id, question}
        <textarea class="general-feedback" cols="40" rows="1" id="#{answer_id}" name="#{answer_id}" placeholder="#{question}"></textarea>
         <div class="text-center">
          <a href="#" id="submit" class="btn btn-default btn-lg btn-continue">
            <i class='fa fa-check'></i> Finished!
          </a>
          <br>
          <span class="hotkey">SHIFT + ENTER</span>
        </div>
      </div>
    ).html_safe
  end

  def survey_tag(question, type, uid)
    case type
      when :yes_or_no then yes_or_no_survey(question, uid)
      when :text      then text_survey(question, uid)
      else raise 'Wrong type of survey'
    end
  end
end
