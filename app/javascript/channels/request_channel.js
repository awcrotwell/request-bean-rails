import consumer from "./consumer";

const regex = /\/bins\/[0-9A-F]{8}\b/gi;

const isBinPage = () => window.location.pathname.match(regex).length > 0;

document.addEventListener("turbo:load", () => {
  const div = document.getElementById("bin_id");
  if (isBinPage && div) {
    const id = div.innerText.trim();

    consumer.subscriptions.create(
      { channel: "RequestChannel", room: id },
      {
        connected() {
          // Called when the subscription is ready for use on the server
          console.log("connected");
        },

        disconnected() {
          // Called when the subscription has been terminated by the server
        },

        received(data) {
          const row1 = `
<td class="px-6 py-4 whitespace-nowrap">
  <div class="flex items-center">
    <div class="flex-shrink-0 h-10 w-10">
      ${data.created_at}
    </div>
  </div>
</td>

<td class="px-6 py-4 whitespace-nowrap">
  <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
    ${data.http_method}
  </span>
</td>

<td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
  <a href="" data-id="${data.id}" class="text-indigo-600 hover:text-indigo-900">
      Show
  </a>
</td>

<td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
  <a data-confirm="Are you sure?" class="text-indigo-600 hover:text-indigo-900" rel="nofollow" data-method="delete" href="/requests/${data.id}">Destroy</a>
</td>
`;

          const row2 = `
<td class="px-6 py-4 whitespace-nowrap">
  <div class="flex items-center">
    <div class="flex-shrink-0 h-10 w-10">
      Payload:
    </div>
  </div>
</td>

<td class="px-6 py-4 whitespace-nowrap">
  <div class="flex items-center">
    <div class="flex-shrink-0 h-10 w-10">
      ${data.payload}
    </div>
  </div>
</td>

<td></td>

<td></td>
`;

          const tr1 = document.createElement("tr");
          tr1.innerHTML = row1;

          const tr2 = document.createElement("tr");

          tr2.innerHTML = row2;
          tr2.classList.add("hidden");
          tr2.dataset.id = `request-${data.id}`;

          document.getElementById("request-table").appendChild(tr1);
          document.getElementById("request-table").appendChild(tr2);
        },
      }
    );
  }
});
