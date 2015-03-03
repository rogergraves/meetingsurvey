class Question
  def self.all
    [
        { question: "Was this meeting relevant to you?", type: :yes_or_no },
        { question: "Was the purpose of this meeting clear?", type: :yes_or_no },
        { question: "Did this meeting have the right people?", type: :yes_or_no },
        { question: "Did this meeting have good communication?", type: :yes_or_no },
        { question: "Were there clear takeaways or action items?", type: :yes_or_no },
        { question: "Any other feedback?", type: :text },
    ]
  end
end