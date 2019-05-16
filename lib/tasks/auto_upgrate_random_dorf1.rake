namespace :job do
  desc "TODO"
  task upgrate: :environment do
    sleep rand 3*60

    User.all.each do  |user|
      break unless check_update user
      @cookies = Relogin.new(user).run
      fake_request @cookies, user

      user.my_villages.shuffle.each do |my_village|
        puts "auto upgrate for #{my_village.name}"

        if my_village.update_inner_list.present?
          UpgrateInDorf.new(@cookies, my_village, user.active).send_request
        end
        RandomUpgrateOutDorf.new(@cookies, my_village, user.active).send_request
      end
      puts "======================================="
    end
  end

  def check_update user
    flag = false
    user.my_villages.each do |my_village|
      if my_village.wait_time < 10
        my_village.update_attributes(wait_time: 0)
        flag = true
        next
      end
      my_village.update_attributes(wait_time: my_village.wait_time - 10)
    end
    return flag
  end

  def fake_request cookies, user
    @headers = {
      cookies: @cookies,
      "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36"
    }
    @param = {
      "boxId": "hero",
      "buttonId": "adventureWhite",
      "ajaxToken": user.ajaxToken
    }
    (0..rand(3)).each do
      RestClient.post "#{user.server}/ajax.php?cmd=getLayoutButtonTitle", @headers, @params
      puts "RestClient.post #{user.server}/ajax.php?cmd=getLayoutButtonTitle, #{@headers}, #{@params}"
      sleep rand*0.5
    end
  end
end
