class ReportPresenter < BasePresenter
  presents :meeting_occurrence

  def yes_or_no_question_report(question)
    %Q(
      <b>#{question[:question]}</b>
      <ul>
        #{answers_html(question, 'yes')}
      </ul>
      <ul>
        #{answers_html(question, 'no')}
      </ul>
    ).html_safe
  end

  def text_question_report(question)
    _answers = questions_and_answers[question[:question]]
    _answers_html = ''
    _answers.each do |_answer|
      _answers_html << "<li>#{mail_to _answer[:email]}<br>#{_answer[:answer]}</li>"
    end

    %Q(
      <b>#{question[:question]}</b>
      <ul>
        #{_answers_html}
      </ul>
    ).html_safe
  end

  def answers_html(question, answer)
    _answers = answers_for(question, answer)
    _answers_html = ''
    _answers.each do |_answer|
      _answers_html << "<li>#{mail_to _answer[:email]} #{" -- #{_answer[:why]}" unless _answer[:why].blank?}</li>"
    end

    %Q(
      #{answer.capitalize}
      #{_answers_html}
    ).html_safe
  end

  def answers_for(question, answer)
    questions_and_answers[question[:question]].select do |q|
      q[:answer] == answer
    end
  end

  # TODO: separate text for singular or plural users
  def refused_users_html
    emails = email_list(refused_users.map(&:email))
    if refused_users.count == 0
      nil
    else
      "#{emails} indicated that they were not present for the meeting.".html_safe
    end
  end

  def missed_users_html
    emails = email_list(missed_users.map(&:email))
    if missed_users.count == 0
      nil
    elsif missed_users.count == 1
      "#{emails} has not yet responded to the survey invite.".html_safe
    else
      "#{emails} have not yet responded to the survey invite.".html_safe
    end
  end

  def summary
    meeting.summary
  end

  def meeting
    @meeting ||= meeting_occurrence.meeting
  end

  def all_participants
    @all_participants ||= meeting_occurrence.meeting.participants
  end

  def refused_users
    @refused_users ||= meeting_occurrence.refused_users
  end

  def missed_users
    meeting_occurrence.missed_users
  end

  def questions_and_answers
    @questions_and_answers ||= meeting_occurrence.questions_and_answers
  end

  def email_list(emails)
    if emails.count == 0
      nil
    elsif emails.count == 1
      "#{mail_to emails.first}".html_safe
    else
      result = emails.map { |email| mail_to email }
      "#{result[0...-1].join(', ')} and #{result.last}".html_safe
    end
  end
end