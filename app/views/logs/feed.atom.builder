atom_feed :language => 'en-US' do |feed|
  feed.title @title
  feed.updated @updated

  @logs.each do |item|
    next if item.created_at.blank?

    feed.entry( item ) do |entry|
      entry.url logs_url(item)
      entry.title item.title
      entry.content "Log posted by #{item.author} of #{@games[item.game]} in category #{@categories[item.category]}.", :type => 'plaintext'

      # the strftime is needed to work with Google Reader.
      entry.updated(item.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) 

      entry.author item.author
    end
  end
end
