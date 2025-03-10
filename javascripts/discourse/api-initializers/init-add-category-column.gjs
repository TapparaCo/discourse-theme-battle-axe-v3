import SortableColumn from "discourse/components/topic-list/header/sortable-column";
import categoryLink from "discourse/helpers/category-link";
import { apiInitializer } from "discourse/lib/api";
import avatar from "discourse/helpers/avatar";
import PluginOutlet from "discourse/components/plugin-outlet";
import formatDate from "discourse/helpers/format-date";
import { hash } from "@ember/helper";

const CategoryHeaderCell = <template>
  <SortableColumn
    @sortable={{@sortable}}
    @order="category"
    @activeOrder={{@activeOrder}}
    @changeSort={{@changeSort}}
    @ascending={{@ascending}}
    @name="category_title"
  />
</template>;

const CategoryItemCell = <template>
  <td class="category topic-list-data">
    {{#unless @topic.isPinnedUncategorized}}
      {{categoryLink @topic.category}}
    {{/unless}}
  </td>
</template>;

const ActivityHeaderCell = <template>
  <SortableColumn
    @sortable={{@sortable}}
    @order="activity"
    @activeOrder={{@activeOrder}}
    @changeSort={{@changeSort}}
    @ascending={{@ascending}}
    @name="search.latest_post"
  />
</template>;
    
const ActivityItemCell = <template>
  <td class="activity topic-list-data">
    <a
      href={{@topic.lastPostUrl}}
    >
      {{avatar
        @topic.lastPoster
        avatarTemplatePath="user.avatar_template"
        usernamePath="user.username"
        namePath="user.name"
        imageSize="small"
      }}
      <span class='latest-info'>
        <span class='name'>{{@topic.last_poster_username}}</span>
        <PluginOutlet
          @name="topic-list-before-relative-date"
          @outletArgs={{hash topic=@topic}}
        />
        {{~formatDate @topic.bumpedAt format="tiny" noTitle="true"~}}
      </span>
    </a>
  </td>
</template>;

export default apiInitializer("0.8", (api) => {
  api.registerValueTransformer("topic-list-columns", ({ value: columns }) => {
    if (api.container.lookup("service:site").desktopView) {
      
      columns.delete("posters");
      columns.delete("activity");

      columns.reposition("views", { before: "replies" });

      columns.add(
        "category",
        { header: CategoryHeaderCell, item: CategoryItemCell },
        { after: "topic"}
      );
      columns.add(
        "activity", 
        { header: ActivityHeaderCell, item: ActivityItemCell }, 
        { after: "replies" }
      );
    }
    return columns;
  });
});
