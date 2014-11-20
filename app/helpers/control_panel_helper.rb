module ControlPanelHelper

  def generate_keypair_link(login)
    ec2 = AWS::EC2.new(:region => "us-west-2")
    key_pair = ec2.key_pairs[current_user.login]

    if key_pair.exists?
      link_to "Replace SSH Key", generate_key_path, 
      data: { confirm: 'Are you sure? Your old key will be removed from AWS!' }, 
      class: 'btn btn-warning', id: 'generate-key', 'data-no-turbolink' => true
    else
      link_to "Generate SSH Key", generate_key_path, 
      class: 'btn', id: 'generate-key', 'data-no-turbolink' => true
    end
  end

end
