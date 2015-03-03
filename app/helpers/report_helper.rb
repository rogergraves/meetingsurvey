module ReportHelper
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

  # TODO: separate text for singular or plural users
  def refused_users(users)
    emails = email_list(users.map(&:email))
    if users.count == 0
      nil
    else
      "#{emails} indicated that they were not present for the meeting.".html_safe
    end
  end

  def missed_users(users)
    emails = email_list(users.map(&:email))
    if users.count == 0
      nil
    elsif users.count == 1
      "#{emails} has not yet responded to the survey invite.".html_safe
    else
      "#{emails} have not yet responded to the survey invite.".html_safe
    end
  end
end
