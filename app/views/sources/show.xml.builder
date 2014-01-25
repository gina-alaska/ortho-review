xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'
xml.source do |x|
  xml.id @source.id
  xml.name @source.name
  xml.state @source.state
  xml.note @source.note.try(:text)
  xml.accepted_at @source.accepted_at, :type => 'datetime'
  xml.rejected_at @source.rejected_at, :type => 'datetime'
  xml.created_at @source.created_at, :type => 'datetime'
  xml.updated_at @source.updated_at, :type => 'datetime'
  xml.flagged_at @source.flagged_at, :type => 'datetime'
end