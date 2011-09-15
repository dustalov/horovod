# encoding: utf-8

class AllowanceValidator < ActiveModel::Validator
  def validate(record)
    raise TypeError unless record.is_a? Rating

    unless record.post.rateable? record.user
      record.errors[:base] << I18n.t('errors.too_fast')
    end

#    recent = Rating.for(record.post, record.user).limit(1).first
#    return unless recent

#    unless Time.now >= (recent.created_at + 24.hours)
#      record.errors[:base] << I18n.t('errors.too_fast')
#    end
  end
end
