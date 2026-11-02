import PluginOutlet from "discourse/components/plugin-outlet";
import SortableColumn from "discourse/components/topic-list/header/sortable-column";
import lazyHash from "discourse/helpers/lazy-hash";
import { apiInitializer } from "discourse/lib/api";
import dAvatar from "discourse/ui-kit/helpers/d-avatar";
import dCategoryLink from "discourse/ui-kit/helpers/d-category-link";
import dFormatDate from "discourse/ui-kit/helpers/d-format-date";

const CategoryHeaderCell = <template>
  <SortableColumn
    @activeOrder={{@activeOrder}}
    @ascending={{@ascending}}
    @changeSort={{@changeSort}}
    @name="category_title"
    @order="category"
    @sortable={{@sortable}}
  />
</template>;

const CategoryItemCell = <template>
  <td class="category topic-list-data">
    {{#unless @topic.isPinnedUncategorized}}
      {{dCategoryLink @topic.category}}
    {{/unless}}
  </td>
</template>;

const ActivityHeaderCell = <template>
  <SortableColumn
    @activeOrder={{@activeOrder}}
    @ascending={{@ascending}}
    @changeSort={{@changeSort}}
    @name="search.latest_post"
    @order="activity"
    @sortable={{@sortable}}
  />
</template>;

const ActivityItemCell = <template>
  <td class="activity topic-list-data">
    <a href={{@topic.lastPostUrl}}>
      {{dAvatar
        @topic.lastPoster
        avatarTemplatePath="user.avatar_template"
        usernamePath="user.username"
        namePath="user.name"
        imageSize="small"
      }}
      <span class="latest-info">
        <span class="name">{{@topic.last_poster_username}}</span>
        <PluginOutlet
          @name="topic-list-before-relative-date"
          @outletArgs={{lazyHash topic=@topic}}
        />
        {{~dFormatDate @topic.bumpedAt format="tiny" noTitle="true"~}}
      </span>
    </a>
  </td>
</template>;

export default apiInitializer((api) => {
  const site = api.container.lookup("service:site");

  api.registerValueTransformer("topic-list-columns", ({ value: columns }) => {
    if (site.desktopView) {
      columns.delete("posters");
      columns.delete("activity");

      columns.reposition("views", { before: "replies" });

      columns.add(
        "category",
        { header: CategoryHeaderCell, item: CategoryItemCell },
        { after: "topic" }
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
