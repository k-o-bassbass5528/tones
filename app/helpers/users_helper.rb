module UsersHelper
    def profile_image_for(user, size: "100x100", css_class: "")
        if user&.profile_image&.attached?
            image_tag user.display_profile_image, size: size, class: "rounded-circle #{css_class}"
        else
            image_tag "no_image.svg", size: size, class: "rounded-circle #{css_class}"
        end
    end
end  