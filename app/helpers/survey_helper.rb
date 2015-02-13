module SurveyHelper
  def yes_or_no_survey(question, uid)
    question_id = "question_#{uid}"
    answer_id = "answer_#{uid}"
    %Q(
      <div id=#{question_id}>
        #{label_tag question_id, question}
        #{hidden_field_tag question_id, question}
        <br>
        #{radio_button_tag answer_id, 'Yes'}
        #{label_tag answer_id, 'Yes', value: 'Yes'}
        <br>
        #{radio_button_tag answer_id, 'No'}
        #{label_tag answer_id, 'No', value: 'No'}
      </div>
    ).html_safe
  end

  def text_survey(question, uid)
    question_id = "question_#{uid}"
    answer_id = "answer_#{uid}"
    %Q(
      <div id=#{question_id}>
        #{label_tag question_id, question}
        #{hidden_field_tag question_id, question}
        <br>
        #{text_area_tag answer_id}
      </div>
    ).html_safe
  end

  def survey_tag(question, type, uid)
    case type
      when :yes_or_no then yes_or_no_survey(question, uid)
      when :text      then text_survey(question, uid)
      else raise 'Wrong type ofsurvey'
    end
  end
end
