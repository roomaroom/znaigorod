desc 'Set for all accounts last visit as last_sign_in if nil'
task :last_visit => :environment do
  puts "nil -> last_sign_in_at"
  puts "==="*10
  bar = ProgressBar.new(Account.where(:last_visit_at => nil).count)
  Account.where(:last_visit_at => nil).each do |a|
    unless a.last_visit_at?
      a.last_visit_at = a.users.first.last_sign_in_at
      a.save!
      bar.increment!
    end
  end
end
