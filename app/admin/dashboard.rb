ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc { I18n.t("active_admin.dashboard") }

  content :title => proc { I18n.t("active_admin.dashboard") } do

    columns do

      column do
        panel "Download count" do
          ul do
            li "Singles available: #{Download.all.find_all { |download| !download.used && download.reference == "single" }.size}"
            li "Albums available: #{Download.all.find_all { |download| !download.used && download.reference == "album" }.size}"
          end
        end
      end

      column do
        panel "Recent Markers" do
          ul do
            Marker.last(5).map do |marker|
              li link_to(marker.email, admin_marker_path(marker))
            end
          end
        end
      end

    end # content
  end
end
