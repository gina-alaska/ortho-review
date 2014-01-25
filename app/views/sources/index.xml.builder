xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'
xml.sources(:type => 'array') do |sources|
  @sources.each do |s|
    xml.source do |x|
      xml.id s.id
      xml.name s.name
      xml.state s.state
      xml.note s.note.try(:text)
      xml.accepted_at s.accepted_at, :type => 'datetime'
      xml.rejected_at s.rejected_at, :type => 'datetime'
      xml.created_at s.created_at, :type => 'datetime'
      xml.updated_at s.updated_at, :type => 'datetime'
      xml.flagged_at s.flagged_at, :type => 'datetime'
    end
  end
end
