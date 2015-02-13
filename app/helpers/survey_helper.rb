module SurveyHelper
  def yes_or_no_survey(question, uid)
    question_id = "question_#{uid}"
    answer_id = "answer_#{uid}"
    # NOTE: Please don't remove this %Q
    # %Q(
    #   <div id=#{question_id}>
    #     #{label_tag question_id, question}
    #     #{hidden_field_tag question_id, question}
    #     <br>
    #     #{radio_button_tag answer_id, 'Yes'}
    #     #{label_tag answer_id, 'Yes', value: 'Yes'}
    #     <br>
    #     #{radio_button_tag answer_id, 'No'}
    #     #{label_tag answer_id, 'No', value: 'No'}
    #   </div>
    # ).html_safe

    #{label_tag answer_id, '<i class="fa fa-thumbs-o-up"></i>'.html_safe, value: 'Yes', class: 'btn btn-default'}
    #{radio_button_tag answer_id, 'Yes', class: 'btn btn-default'}
    #{radio_button_tag answer_id, 'No'}
    #{label_tag answer_id, '<i class="fa fa-thumbs-o-down"></i>'.html_safe, value: 'No', class: 'btn btn-default'}

    # %Q(
    #   <div id=#{question_id} class='question text-center' data-toggle="buttons">
    #     <h3>#{question}</h3>
    #     #{hidden_field_tag question_id, question}
    #     <br>
    #
    #     #{label_tag answer_id, class: 'btn btn-default' do
    #         radio_button_tag(answer_id, 'Yes') + "<i class='fa fa-thumbs-o-up'></i>".html_safe
    #       end}
    #
    #     #{label_tag answer_id, class: 'btn btn-default' do
    #       radio_button_tag(answer_id, 'No') + "<i class='fa fa-thumbs-o-down'></i>".html_safe
    #       end}
    #
    #   </div>
    # ).html_safe

    %Q(
      <div class="question text-center">
        <h3>#{question}</h3>
        #{hidden_field_tag question_id, question}
        <div id=#{question_id} class="question btn-group" data-toggle="buttons">
          <label class="btn btn-primary active">
            <input type="radio" name="#q{answer_id}" id="#{answer_id}_yes" autocomplete="off" checked>Yes
          </label>
          <label class="btn btn-primary">
            <input type="radio" name="#q{answer_id}" id="#{answer_id}_no" autocomplete="off">No
          </label>
        </div>
      </div>
      <br>
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
