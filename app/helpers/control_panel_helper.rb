module ControlPanelHelper

  def generate_keypair_link(login)
    ec2 = AWS::EC2.new(:region => "us-west-2")
    key_pair = ec2.key_pairs[current_user.login]

    if key_pair.exists?
      link_to "Replace SSH Key", generate_key_path, 
      data: { confirm: 'Are you sure? Your old key will be removed from AWS!' }, 
      class: 'btn btn-warning', id: 'generate-key', 'data-no-turbolink' => true,
      :remote => true
    else
      link_to "Generate SSH Key", generate_key_path, 
      data: { confirm: 'IMPORTANT: You will not be able to download this ' +
        'key again after you hit OK. Please take care to store your key securely ' +
        'and under no circumstances should you share your key with anyone.' }, 
      class: 'btn', id: 'generate-key', 'data-no-turbolink' => true,
      :remote => true
    end
  end

end
