module MailingList
  LIST_ID = '0bb555fb4b8a6800ea5266d892f28630'

  def self.add_subscriber(marker)
    CreateSend::Subscriber.add LIST_ID, marker.email, nil, nil, false
  end
end
