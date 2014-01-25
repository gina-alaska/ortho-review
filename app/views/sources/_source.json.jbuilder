json.(source, :id, :name, :state, :created_at, :updated_at, :accepted_at, :rejected_at, :flagged_at)
json.note source.note.try(:text)