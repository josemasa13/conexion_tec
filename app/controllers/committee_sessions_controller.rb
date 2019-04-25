class CommitteeSessionsController < ApplicationController
    include AuthHelper

    ITESM_MAIL = /^[a-zA-Z0-9_.+-]+@(?:(?:[a-zA-Z0-9-]+\.)?[a-zA-Z]+\.)?(itesm|tec)\.mx$/

    def new
        if current_user && current_user.committee?
            redirect_to committee_profile_path
        else
            @login_url = get_login_url(authorize_committee_url)
        end
    end

    # This method is in charge of redirecting to committee profile if info is valid
    def create
        token = get_token_from_code(params[:code], authorize_committee_url)
        raw_information = token.get('https://graph.microsoft.com/v1.0/me').parsed

        mail = raw_information['mail'] || raw_information['userPrincipalName']
        full_name = raw_information['displayName']

        user = User.find_by(email: mail)
        if user # The user exists, login to the system
            url = committee_profile_path
        else # The user is not on the database
            url = committee_edit_path
            if mail.match(ITESM_MAIL) # Check if it is from the ITESM
                user = create_committee(mail,full_name)
            else #committee mail is not from ITESM 
                flash.now[:danger] = 'Correo invalido: favor de utilizar correo del ITESM.'
                render 'new'
            end
        end
        login_redirect(user, url)
    end

    # Login user and redirect page to another path
    def login_redirect(user, url)
        auto_login(user)
        redirect_to url
    end

    # Handle internal committee
    def create_committee(mail,full_name)
        # Create the user and login
        committee = Committee.create()
        password = generates_password
        user = User.create(email: mail,
                            name: full_name,
                            userable_type: 'Committee',
                            userable_id: committee.id,
                            password: password,
                            password_confirmation: password)

        user
    end

    # Generates random password
    def generates_password
        SecureRandom.base64(10)
    end

    def destroy
        logout
        redirect_to login_committee_path
    end
end
