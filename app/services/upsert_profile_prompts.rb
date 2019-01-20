class UpsertProfilePrompts < BaseService
  def call(user:, submitted_prompts:)
    @user = user
    @prompt_errors = []

    submitted_prompts.each do |hash|
      stem = hash.fetch(:stem)
      response = hash.fetch(:response)
      existing = find_existing_prompt(stem: stem)
      try_create_or_update_or_destroy_prompt(existing, stem, response)
    end

    @prompt_errors
  end

  def find_existing_prompt(stem:)
    @existing_prompts ||= @user.profile_prompts.to_a
    @existing_prompts.find { |p| p.stem == stem }
  end

  def try_create_or_update_or_destroy_prompt(existing, stem, response)
    case
    when existing && response.present?
      existing.update(response: response) || report_prompt_error(existing)
    when existing && response.blank?
      existing.destroy!
    when !existing && response.present?
      new_prompt = @user.profile_prompts.new(stem: stem, response: response)
      new_prompt.save || report_prompt_error(new_prompt)
    when !existing && response.blank?
      # do nothing
    end
  end

  def report_prompt_error(prompt)
    @prompt_errors << "Prompt \"#{prompt.stem}\": #{prompt.errors.full_messages.join(", ")}. "
  end
end
