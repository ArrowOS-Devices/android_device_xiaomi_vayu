/*
 * Copyright (C) 2020-2021 The LineageOS Project
 * Copyright (C) 2020-2021 Chaldeaprjkt
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 * *    * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above
 *       copyright notice, this list of conditions and the following
 *       disclaimer in the documentation and/or other materials provided
 *       with the distribution.
 *     * Neither the name of The Linux Foundation nor the names of its
 *       contributors may be used to endorse or promote products derived
 *       from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
 * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#define LOG_TAG "QTI PowerHAL"

#include <log/log.h>

#include <aidl/android/hardware/power/BnPower.h>

extern "C" {

#include "hint-data.h"
#include "metadata-defs.h"
#include "performance.h"
#include "power-common.h"
#include "utils.h"

const int kMinInteractiveDuration = 100;  /* ms */
const int kMaxInteractiveDuration = 5000; /* ms */

static int process_interaction_hint(void* data) {
    static struct timespec s_previous_boost_timespec;
    static int s_previous_duration = 0;
    static int interaction_handle = -1;

    struct timespec cur_boost_timespec;
    long long elapsed_time;
    int duration = kMinInteractiveDuration;

    if (data) {
        int input_duration = *((int*)data);
        if (input_duration > duration) {
            duration = (input_duration > kMaxInteractiveDuration) ? kMaxInteractiveDuration
                                                                  : input_duration;
        }
    }

    clock_gettime(CLOCK_MONOTONIC, &cur_boost_timespec);

    elapsed_time = calc_timespan_us(s_previous_boost_timespec, cur_boost_timespec);
    // don't hint if it's been less than 250ms since last boost
    // also detect if we're doing anything resembling a fling
    // support additional boosting in case of flings
    if (elapsed_time < 250000 && duration <= 750) {
        return HINT_HANDLED;
    }
    s_previous_boost_timespec = cur_boost_timespec;
    s_previous_duration = duration;

    if (CHECK_HANDLE(interaction_handle)) {
        release_request(interaction_handle);
    }

    interaction_handle = perf_hint_enable_with_type(VENDOR_HINT_SCROLL_BOOST,
                                                    duration, SCROLL_VERTICAL);
    if (!CHECK_HANDLE(interaction_handle)) {
        ALOGE("Failed to perform interaction boost");
        return HINT_NONE;
    }
    return HINT_HANDLED;
}
}

using ::aidl::android::hardware::power::Boost;

namespace aidl {
namespace android {
namespace hardware {
namespace power {
namespace impl {

bool isDeviceSpecificBoostSupported(Boost type, bool *_aidl_return) {
    switch (type) {
        case Boost::INTERACTION:
            *_aidl_return = true;
            return true;
        default:
            return false;
    }
}

bool setDeviceSpecificBoost(Boost type, int32_t durationMs) {
    switch (type) {
        case Boost::INTERACTION:
            process_interaction_hint(&durationMs);
            return true;
        default:
            return false;
    }
}

} // namespace impl
} // namespace power
} // namespace hardware
} // namespace android
} // namespace aidl
