ActiveAdmin.register User do

  permit_params :email, :password, :name

  index do
    column :email
    column :sign_in_count
    actions
  end

  show do
    attributes_table do
      row :email
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
      row :created_at
      row :updated_at
    end
  end

  filter :email

  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :password
      f.input :name
    end
    f.actions
  end

  controller do

    def update
      user = User.find(params[:id])
      user.email = params[:user][:email]
      user.password = params[:user][:password]
      user.name = params[:user][:name]
      error_message = nil

      begin
        user.skip_confirmation_notification!
        user.skip_reconfirmation!
        user.save!
      rescue Exception => e
        error_message = e.message
      end

      redirect_to admin_user_path(user), :notice => ("Successfully updated!" unless error_message), :alert => error_message
    end

  end

end
